import 'dart:convert';
import 'package:get/get.dart';
import '../common.dart';

class UserStore extends GetxController {
  static UserStore get to => Get.find();

  // Login Check
  final _isLogin = false.obs;
  // User token
  String token = '';
  // User profile
  final _profile = UserLoginResponseEntity().obs;

  bool get isLogin => _isLogin.value;
  UserLoginResponseEntity get profile => _profile.value;
  bool get hasToken => token.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    token = StorageService.to.getString(STORAGE_USER_TOKEN_KEY);
    var profileOffline = StorageService.to.getString(STORAGE_USER_PROFILE_KEY);
    if (profileOffline.isNotEmpty) {
      _isLogin.value = true;
      _profile(UserLoginResponseEntity.fromJson(jsonDecode(profileOffline)));
    }
  }

  // setting the token into key
  Future<void> setToken(String value) async {
    await StorageService.to.setString(STORAGE_USER_TOKEN_KEY, value);
    token = value;
  }

  Future<String> getUserType() async {
    return StorageService.to.getString(STORAGE_USER_TYPE);
  }

  // Get Profile data
  Future<String> getProfile() async {
    if (token.isEmpty) return "";
    // var result = await UserAPI.profile();
    // _profile(result);
    // _isLogin.value = true;
    return StorageService.to.getString(STORAGE_USER_PROFILE_KEY);
  }

  Future<void> saveProfile(UserLoginResponseEntity profile) async {
    _isLogin.value = true;
    StorageService.to.setString(STORAGE_USER_PROFILE_KEY, jsonEncode(profile));
    StorageService.to.setString(STORAGE_USER_TYPE, jsonEncode(profile.type));
    setToken(profile.accessToken!);
    //Device to Device Chat
    _profile(profile);
  }

  // Token SignOut
  Future<void> onLogout() async {
    // if (_isLogin.value) await UserAPI.logout();
    await StorageService.to.remove(STORAGE_USER_TOKEN_KEY);
    await StorageService.to.remove(STORAGE_USER_PROFILE_KEY);
    await StorageService.to.remove(STORAGE_USER_TYPE);
    _isLogin.value = false;
    token = '';
  }
}
