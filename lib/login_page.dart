import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:get/get.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage();

  @override
  State<LoginPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoginPage> {
  bool isBiometricsAvailable = false;
  final localAuth = LocalAuthentication();

  void successLogin(){
    Get.snackbar(
      "로그인 성공",
      "카카오계정으로 로그인 되었습니다.",
      colorText: Colors.white,
      backgroundColor: Colors.lightBlue,
      icon: const Icon(Icons.add_alert),
    );
    Get.off(() => HomePage());
  }

  void kakaoLogin() async {
    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        successLogin();
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          successLogin();
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        successLogin();
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  void checkKakaoToken() async {
    if (await AuthApi.instance.hasToken()) {
      try {
        var token = await UserApi.instance.accessTokenInfo();
        successLogin();
      } catch (error) {
        if (error is KakaoException && error.isInvalidTokenError()) {
          print('토큰 만료 $error');
        } else {
          print('토큰 정보 조회 실패 $error');
        }
      }
    } else {
      print('발급된 토큰 없음');
    }
  }

  void checkBiometrics() async {
    if (await localAuth.canCheckBiometrics &&
        await localAuth.isDeviceSupported()) {
      final availableBiometrics = await localAuth.getAvailableBiometrics();
      print(availableBiometrics);
      if (availableBiometrics.isNotEmpty) {
        setState(() {
          isBiometricsAvailable = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkKakaoToken();
    checkBiometrics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("zihasoo flutter tech"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Stack(
              children: [
                Image.asset(
                  "assets/images/kakao_login_image.png",
                  scale: 1.2,
                ),
                Positioned.fill( //스택에서 자리잡을 때 쓰는 위젯
                    child: Material( //이 위젯이 있어야지 잉크 효과가 보임
                      color: Colors.transparent,
                      child: InkWell( //제스쳐디텍터 + 잉크퍼짐효과 위젯
                        onTap: kakaoLogin,
                      ),
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                  onPressed: isBiometricsAvailable ? () async {
                    bool authenticateSuccess = await localAuth.authenticate(
                      localizedReason: '지문 인식 해보셈',
                      authMessages: const [
                        AndroidAuthMessages(
                          signInTitle: '생체 인증으로 로그인하기',
                          cancelButton: '취소하기',
                        ),
                        IOSAuthMessages(
                          cancelButton: '취소하기',
                        ),
                      ],
                      options: const AuthenticationOptions(biometricOnly: true),
                    );
                    if(authenticateSuccess){
                      Get.snackbar(
                        "로그인 성공",
                        "생체 인증으로 로그인 했음\n근데 화면 넘어갈려면 카카오 로그인 해야됨",
                        colorText: Colors.white,
                        backgroundColor: Colors.lightBlue,
                        icon: const Icon(Icons.add_alert),
                      );
                    }
                  } : null,
                  style: Theme.of(context).textButtonTheme.style,
                  child: Text("생체 인증하기",
                      style: Theme.of(context).textTheme.bodyLarge)),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
