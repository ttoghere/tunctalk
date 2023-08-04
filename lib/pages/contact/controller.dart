import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../common/common.dart';
import '../pages.dart';


class ContactController extends GetxController {
  final state = ContactState();
  ContactController();
  final db = FirebaseFirestore.instance;
  final token = UserStore.to.token;

  asyncLoadAllData() async {
    var userBase = await db
        .collection("users")
        .where("id", isNotEqualTo: token)
        .withConverter(
            fromFirestore: UserData.fromFirestore,
            toFirestore: (UserData userData, options) => userData.toFirestore())
        .get();
    for (var doc in userBase.docs) {
      state.contactList.add(doc.data());
      log(doc.toString());
    }
  }

  goChat(UserData to_userdata) async {
    var from_message = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg message, options) => message.toFirestore())
        .where("from_uid", isEqualTo: token)
        .where("to_uid", isEqualTo: to_userdata.id)
        .get();
    var to_message = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg message, options) => message.toFirestore())
        .where("from_uid", isEqualTo: to_userdata.id)
        .where("to_uid", isEqualTo: token)
        .get();

    if (from_message.docs.isEmpty && to_message.docs.isEmpty) {
      String profile = await UserStore.to.getProfile();
      UserLoginResponseEntity userdata =
          UserLoginResponseEntity.fromJson(json.decode(profile));
      var msg_data = Msg(
        from_uid: userdata.accessToken,
        to_uid: to_userdata.id,
        from_avatar: userdata.photoUrl,
        from_name: userdata.displayName,
        to_avatar: to_userdata.photourl,
        to_name: to_userdata.name,
        last_msg: "",
        last_time: Timestamp.now(),
        msg_num: 0,
      );
      db
          .collection("message")
          .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore(),
          )
          .add(msg_data)
          .then((value) {
        Get.toNamed("/chat", parameters: {
          "doc_id": value.id,
          "to_uid": to_userdata.id ?? "",
          "to_name": to_userdata.name ?? "",
          "to_avatar": to_userdata.photourl ?? "",
        });
      });
    } else {
      if (from_message.docs.isNotEmpty) {
        Get.toNamed("/chat", parameters: {
          "doc_id": from_message.docs.first.id,
          "to_uid": to_userdata.id ?? "",
          "to_name": to_userdata.name ?? "",
          "to_avatar": to_userdata.photourl ?? "",
        });
      } if (to_message.docs.isNotEmpty) {
        Get.toNamed("/chat", parameters: {
          "doc_id": to_message.docs.first.id,
          "to_uid": to_userdata.id ?? "",
          "to_name": to_userdata.name ?? "",
          "to_avatar": to_userdata.photourl ?? "",
        });
      }
    }
  }

  @override
  void onReady() {
    asyncLoadAllData();
    super.onReady();
  }
}
