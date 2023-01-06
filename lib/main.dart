import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() async {
  KakaoSdk.init(
    nativeAppKey: "8ef3614d5eca7c9213a0e0cf27c7ee87",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'zihasoo flutter tech',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
            bodyLarge: TextStyle(
                fontSize: 25, fontFamily: "Pretendard", color: Colors.white),
          ),
          textButtonTheme: TextButtonThemeData(
              style: ElevatedButton.styleFrom(fixedSize: Size(300, 70)))),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoggedIn = false;

  void kakaoLogin() async {
    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
    setState(() {
      isLoggedIn = true;
    });
  }

  Future<bool> checkKakaoToken() async {
    if (await AuthApi.instance.hasToken()) {
      try {
        var token = await UserApi.instance.accessTokenInfo();
        print('토큰 유효성 체크 성공: ');
        print(token);
        return true;
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
    return false;
  }

  @override
  void initState() {
    super.initState();
    checkKakaoToken().then((value) => isLoggedIn = value);
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
            Padding(
              padding: EdgeInsets.all(20),
              child: const Text(
                "카카오 로그인 화면임",
                style: TextStyle(fontSize: 35, fontFamily: "Pretendard"),
              ),
            ),
            Stack(
              children: [
                Image.asset(
                  "assets/images/kakao_login_image.png",
                  scale: 1.2,
                ),
                Positioned.fill(
                    //스택에서 자리잡을 때 쓰는 위젯
                    child: Material(
                  //이 위젯이 있어야지 잉크 효과가 보임
                  color: isLoggedIn
                      ? Color.fromRGBO(50, 50, 50, 0.2)
                      : Colors.transparent,
                  child: InkWell(
                    //제스쳐디텍터 + 잉크퍼짐효과 위젯
                    onTap: isLoggedIn ? null : kakaoLogin,
                  ),
                ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                  onPressed: isLoggedIn
                      ? () async {
                          var user = await UserApi.instance.me();
                          print(user);
                        }
                      : null,
                  style: Theme.of(context).textButtonTheme.style,
                  child: Text("사용자 정보 보기",
                      style: Theme.of(context).textTheme.bodyLarge)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                  onPressed: isLoggedIn
                      ? () async {
                          try {
                            await UserApi.instance.logout();
                            print("로그아웃 되었습니다.");
                            setState(() {
                              isLoggedIn = false;
                            });
                          } catch (err) {
                            print("카카오 로그아웃 실패: $err");
                          }
                        }
                      : null,
                  style: Theme.of(context).textButtonTheme.style,
                  child: Text("로그아웃 하기",
                      style: Theme.of(context).textTheme.bodyLarge)),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
