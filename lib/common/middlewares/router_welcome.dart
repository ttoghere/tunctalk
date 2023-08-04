// ignore_for_file: depend_on_referenced_packages, overridden_fields

import 'package:flutter/material.dart';
import '../common.dart';
import 'package:get/get.dart';
import 'dart:developer';
/// first welcome page
class RouteWelcomeMiddleware extends GetMiddleware {
  // Small numbers have high priority
  @override
  int? priority = 0;

  RouteWelcomeMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {
    log(ConfigStore.to.isFirstOpen.toString());
    if (ConfigStore.to.isFirstOpen == false) {
      return null;
    } else if (UserStore.to.isLogin == true) {
      return const RouteSettings(name: AppRoutes.Application);
    } else {
      return const RouteSettings(name: AppRoutes.SIGN_IN);
    }
  }
}
