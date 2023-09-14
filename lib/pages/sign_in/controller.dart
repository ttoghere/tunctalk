import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tunctalk/pages/global.dart';
import '../../common/common.dart';
import '../pages.dart';

class SignInController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      "openid",
    ],
  );
  final state = SignInState();
  SignInController();
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  Future<void> handleSignIn({required String type}) async {
    try {
      if (type == "google") {
        var user = await _googleSignIn.signIn();
        log("Break 1");
        if (user != null) {
          final gAuthentication = await user.authentication;
          final credential = GoogleAuthProvider.credential(
            idToken: gAuthentication.idToken,
            accessToken: gAuthentication.accessToken,
          );
          log("Break 2");

          await auth.signInWithCredential(credential);
          log("Break 3");

          String displayName = user.displayName ?? user.email;
          String email = user.email;
          String id = user.id;
          String photoUrl = user.photoUrl ?? nullPicUrl;
          //A model for manipulating user information
          UserLoginResponseEntity userProfile = UserLoginResponseEntity();
          userProfile.email = email;
          userProfile.accessToken = id;
          userProfile.displayName = displayName;
          userProfile.photoUrl = photoUrl;
          userProfile.type = "google";
          //Controller for storing user data and status
          UserStore.to.saveProfile(userProfile);
          log("Break 4");

          //Gets user data from firestore
          var userbase = await db
              .collection("users")
              .withConverter(
                fromFirestore: UserData.fromFirestore,
                toFirestore: (UserData userData, options) =>
                    userData.toFirestore(),
              )
              .where("id", isEqualTo: id)
              .get();
          log("Break 5");

          //Checking the users existence
          if (userbase.docs.isEmpty) {
            final data = UserData(
              id: id,
              name: displayName,
              email: email,
              photourl: photoUrl,
              location: "",
              fcmtoken: "",
              addtime: Timestamp.now(),
            );
            //Saves data to firestore
            await db
                .collection("users")
                .withConverter(
                  fromFirestore: UserData.fromFirestore,
                  toFirestore: (UserData userData, options) =>
                      userData.toFirestore(),
                )
                .add(data);
            log("Break 6");
          }
          toastInfo(msg: "Login Success");
          Get.offAndToNamed(AppRoutes.Application);
        }
      } else if (type == "facebook") {
        var auth = await signInWithFacebook();
        if (auth.user != null) {
          String? displayName = auth.user!.displayName;
          String? email = auth.user!.email;
          String? id = auth.user!.uid;
          String? photoUrl = auth.user!.photoURL ?? nullPicUrl;
          //A model for manipulating user information
          UserLoginResponseEntity userProfile = UserLoginResponseEntity();
          userProfile.email = email;
          userProfile.accessToken = id;
          userProfile.displayName = displayName;
          userProfile.photoUrl = photoUrl;
          userProfile.type = "facebook";
          //Controller for storing user data and status
          UserStore.to.saveProfile(userProfile);
          log("Break 4");

          //Gets user data from firestore
          var userbase = await db
              .collection("users")
              .withConverter(
                fromFirestore: UserData.fromFirestore,
                toFirestore: (UserData userData, options) =>
                    userData.toFirestore(),
              )
              .where("id", isEqualTo: id)
              .get();
          log("Break 5");

          //Checking the users existence
          if (userbase.docs.isEmpty) {
            final data = UserData(
              id: id,
              name: displayName,
              email: email,
              photourl: photoUrl,
              location: "",
              fcmtoken: "",
              addtime: Timestamp.now(),
            );
            //Saves data to firestore
            await db
                .collection("users")
                .withConverter(
                  fromFirestore: UserData.fromFirestore,
                  toFirestore: (UserData userData, options) =>
                      userData.toFirestore(),
                )
                .add(data);
            log("Break 6");
          }
          toastInfo(msg: "Login Success");
          Get.offAndToNamed(AppRoutes.Application);
        }
      } else if (type == "apple") {}
    } catch (e) {
      toastInfo(msg: "Login Error: $e");
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();
    OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  @override
  void onReady() {
    super.onReady();
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        log("User is currently logged out");
      } else {
        log("User is logged in");
      }
    });
  }
}
