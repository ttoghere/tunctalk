import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tunctalk/common/utils/notification_helper.dart';
import 'package:tunctalk/pages/global.dart';
import 'common/common.dart';

Future<dynamic> backgroundMessageHandler(
    {required RemoteMessage remoteMessage}) async {
  log("...onBackground: ${remoteMessage.notification?.title}/${remoteMessage.notification?.body}");
}

void main() async {
  await Global.init();
  await FirebaseMessaging.instance.getInitialMessage();
  try {
    await NotificationHelper.init();
    FirebaseMessaging.onBackgroundMessage(
        (message) => backgroundMessageHandler(remoteMessage: message));
  } catch (e) {
    log("...couldn't init: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //We have to wrap material with ScreenUtilInit
    //This wrap action let us to use adaptive sizes in app
    return ScreenUtilInit(
      builder: (context, child) {
        //Must implement widget GetMaterial app
        //For using get package features in app
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TuncTalk',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          //MaterialApp --> routes
          getPages: AppPages.routes,
          initialRoute: AppPages.initial,
        );
      },
    );
  }
}
