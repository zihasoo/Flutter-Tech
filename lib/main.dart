import 'package:flutter/material.dart';

import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:get/get.dart';

import 'login_page.dart';

void main() async {
  KakaoSdk.init(
    nativeAppKey: "8ef3614d5eca7c9213a0e0cf27c7ee87",
  );
  runApp(const ZihasooApp());
}

class ZihasooApp extends StatelessWidget {
  const ZihasooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'zihasoo flutter tech',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
            bodyLarge: TextStyle(
                fontSize: 25, fontFamily: "Pretendard", color: Colors.white),
          ),
          textButtonTheme: TextButtonThemeData(
              style: ElevatedButton.styleFrom(fixedSize: Size(300, 70)))),
      home: const LoginPage(),
    );
  }
}