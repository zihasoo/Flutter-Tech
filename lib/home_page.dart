import 'package:flutter/material.dart';
import 'package:flutter_tech/canvas_page.dart';

import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:vibration/vibration.dart';

import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<User>? user;

  @override
  void initState() {
    super.initState();
    user = UserApi.instance.me();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              FutureBuilder(
                future: user,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return OutlinedButton(
                      onPressed: () {
                        Get.defaultDialog(
                          title: "내 프로필",
                          content: Text(snapshot.data.toString()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          children: [
                            ClipOval(
                              //이미지 동그랗게 만들어주는 위젯
                              child: Image.network(snapshot
                                  .data!.properties!["thumbnail_image"]!),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                snapshot.data!.properties!["nickname"]!,
                                style: TextStyle(
                                    fontSize: 25, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                style: Theme.of(context).textButtonTheme.style,
                onPressed: () async {
                  await UserApi.instance.logout();
                  Get.snackbar(
                    "로그아웃 되었습니다.",
                    "로그인 화면으로 돌아갑니다.",
                    colorText: Colors.white,
                    backgroundColor: Colors.lightBlue,
                    icon: const Icon(Icons.add_alert),
                  );
                  Get.off(() => LoginPage());
                },
                child: Text(
                  "로그아웃 하기",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: Theme.of(context).textButtonTheme.style,
                onPressed: () async {
                  Vibration.vibrate(pattern: [200,200,200,200]);
                },
                child: Text("진동 울리기",
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: Theme.of(context).textButtonTheme.style,
                onPressed: () async {
                  Get.to(() => CanvasPage());
                },
                child: Text("캔버스 페이지로 가기",
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
