import 'dart:convert';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import '../../common/common.dart';
import '../pages.dart';

class ProfileController extends GetxController {
  ProfileController();
  final state = ProfileState();
  // final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
  //   "email",
  //   "https://www.googleapis.com/auth/contacts.readonly"
  // ]);

  asyncLoadAllData() async {
    String profile = await UserStore.to.getProfile();
    if (profile.isNotEmpty) {
      UserLoginResponseEntity userdata =
          UserLoginResponseEntity.fromJson(jsonDecode(profile));
      state.headDetail.value = userdata;
    }
  }

  Future<void> onLogOut() async {
    var type = utf8.encode(StorageService.to.getString(STORAGE_USER_TYPE));
    var googleType = utf8.encode("google");
    var facebookType = utf8.encode("facebook");
    if (type.toString() == googleType.toString()) {
      await SignInController().signOut();
    } else if (type.toString() == facebookType.toString()) {
      await FacebookAuth.instance.logOut();
    }

    UserStore.to.onLogout();

    Get.offAndToNamed(AppRoutes.SIGN_IN);
  }

  @override
  void onInit() {
    super.onInit();
    asyncLoadAllData();
    List myList = [
      {"name": "Account", "icon": "assets/icons/1.png", "route": "/account"},
      {"name": "Chat", "icon": "assets/icons/2.png", "route": "/message"},
      {
        "name": "Notification",
        "icon": "assets/icons/3.png",
        "route": "/notification"
      },
      {"name": "Privacy", "icon": "assets/icons/4.png", "route": "/privacy"},
      {"name": "Help", "icon": "assets/icons/5.png", "route": "/help"},
      {"name": "About", "icon": "assets/icons/6.png", "route": "/about"},
      {"name": "Log Out", "icon": "assets/icons/7.png", "route": "/logout"},
    ];

    for (int i = 0; i < myList.length; i++) {
      MeListItem result = MeListItem();
      result.icon = myList[i]["icon"];
      result.name = myList[i]["name"];
      result.route = myList[i]["route"];
      state.meListItem.add(result);
    }
  }
}
