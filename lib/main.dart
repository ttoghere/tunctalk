import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tunctalk/firebase_options.dart';
import 'common/common.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Get.putAsync<StorageService>(() => StorageService().init());
  Get.put<ConfigStore>(ConfigStore());
  Get.put<UserStore>(UserStore());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

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
          initialRoute: FirebaseAuth.instance.currentUser != null
              ? AppPages.application
              : AppPages.initial,
        );
      },
    );
  }
}
