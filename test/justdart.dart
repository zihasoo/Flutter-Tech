import 'dart:io';

void main() {
  int n = int.parse(stdin.readLineSync()!);
  if (n == 1 || n % 2 == 0) {
    print("소수아님");
    return;
  }
  for (int i = 3; i * i <= n; i += 2) {
    if (n % i == 0) {
      print("소수아님");
      return;
    }
  }
  print("소수맞음");
}
