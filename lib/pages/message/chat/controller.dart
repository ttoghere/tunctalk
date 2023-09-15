import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../common/common.dart';
import '../../pages.dart';
import 'package:path/path.dart';

class ChatController extends GetxController {
  final state = ChatState();
  dynamic doc_id;
  final textController = TextEditingController();
  FocusNode focusNode = FocusNode();
  ScrollController scrollController = ScrollController();
  String user_id = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  dynamic listener;
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  ChatController();
  var userProfile = UserStore.to.profile;
  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;
    doc_id = data["doc_id"];
    state.toUID.value = data["to_uid"] ?? "";
    state.toName.value = data["to_name"] ?? "";
    state.toAvatar.value = data["to_avatar"] ?? "";
  }

  //Notification
  void noti() async {
    final FirebaseMessaging fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    final token = await fcm.getToken();
    log("Token: $token");
  }

  //Send the message to database
  sendMessage() async {
    String sendContent = textController.text;
    final content = Msgcontent(
        uid: user_id,
        content: sendContent,
        type: "text",
        addtime: Timestamp.now());
    await db
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
          fromFirestore: Msgcontent.fromFirestore,
          toFirestore: (Msgcontent msg, options) => msg.toFirestore(),
        )
        .add(content)
        .then((DocumentReference doc) {
      log("Document Snapshot added with id, ${doc.id}");
      textController.clear();
      Get.focusScope?.unfocus();
    });
    await db.collection("message").doc(doc_id).update({
      "last_msg": sendContent,
      "last_time": Timestamp.now(),
    });
    var userbase = await db
        .collection("users")
        .withConverter(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (UserData userData, options) => userData.toFirestore(),
        )
        .where("id", isEqualTo: state.toUID.value)
        .get();
    if (userbase.docs.isNotEmpty) {
      var title = "Message made by ${userProfile.displayName}";
      var body = sendContent;
      var token = userbase.docs.first.data().fcmtoken;
      print(token);
      if (token != null) {
        // sendNotification(title, body, token);
      }
    }
  }

  Future<void> sendNotification(
      {required String title,
      required String body,
      required String token}) async {
    const String url = "https://fcm.googleapis.com/fcm/send";

    final response = await http.post(Uri.parse(url), headers: <String, String>{
      "Content-type": "application/json",
      "Keep-alive": "timeout=5",
      "Authorization":
          "key=AAAAT9GcIGo:APA91bEQhh7wevVsXv1ZciWfJTt65TMPNa39AYr3gI8wrIpDnQQPHtMfHZpfWS0oZDUIGd8_S_K1pI6eOstnGk9IezyDcGWAJW-8AorxI_jgMJNr8zcBGz-wIDNUI38rr5eG5OUb4XDQ"
    }, body: {
      "body": body,
      "title": title,
      "priority": "high",
      "to": token,
    });
    log("Result: ${response.body}");
  }

  //
  @override
  void onReady() {
    super.onReady();
    noti();
    var messages = db
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msg, options) => msg.toFirestore())
        .orderBy("addtime", descending: false);
    state.msgContentList.clear();
    listener = messages.snapshots().listen(
      (event) {
        for (var change in event.docChanges) {
          switch (change.type) {
            case DocumentChangeType.added:
              if (change.doc.data() != null) {
                state.msgContentList.insert(0, change.doc.data()!);
              }
              break;
            case DocumentChangeType.modified:
              break;
            case DocumentChangeType.removed:
              break;
          }
        }
      },
      onError: (value) => log("Listen Failed: $value"),
      onDone: () => log("Listen Success"),
    );
    getNavLocation();
  }

  @override
  void dispose() {
    scrollController.dispose();
    listener.cancel();
    super.dispose();
  }

  Future imgFromGallery(context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadFile();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No image picked !!")));
    }
  }

  Future getImgUrl(String name) async {
    final spaceRef = FirebaseStorage.instance.ref("chat").child(name);
    var str = await spaceRef.getDownloadURL();
    return str;
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = getRandomString(15) + extension(_photo!.path);
    try {
      final ref = FirebaseStorage.instance.ref("chat").child(fileName);
      ref.putFile(_photo!).snapshotEvents.listen((event) async {
        switch (event.state) {
          case TaskState.paused:
            break;
          case TaskState.running:
            break;
          case TaskState.success:
            String url = await getImgUrl(fileName);
            sendImageMessage(url);
            break;
          case TaskState.canceled:
            break;
          case TaskState.error:
            break;
        }
      });
    } catch (e) {
      log("There is an error $e");
    }
  }

  sendImageMessage(String url) async {
    final content = Msgcontent(
      uid: user_id,
      content: url,
      type: "image",
      addtime: Timestamp.now(),
    );

    await db
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
          fromFirestore: Msgcontent.fromFirestore,
          toFirestore: (Msgcontent msg, options) => msg.toFirestore(),
        )
        .add(content)
        .then((DocumentReference doc) {
      log("Document Snapshot added with id, ${doc.id}");
      textController.clear();
      Get.focusScope?.unfocus();
    });
    await db.collection("message").doc(doc_id).update({
      "last_msg": "[image]",
      "last_time": Timestamp.now(),
    });
  }

  getNavLocation() async {
    try {
      var user_location = await db
          .collection("users")
          .where("id", isEqualTo: state.toUID.value)
          .withConverter(
            fromFirestore: UserData.fromFirestore,
            toFirestore: (UserData data, options) => data.toFirestore(),
          )
          .get();
      log("Location nav 1");
      var location = user_location.docs.first.data().location;
      log("Location nav 2");

      if (location != "") {
        state.toLocation.value = location ?? "Unknown";
        log("Location nav 3");
      }
    } catch (e) {
      log("We have an error $e");
    }
  }
}
