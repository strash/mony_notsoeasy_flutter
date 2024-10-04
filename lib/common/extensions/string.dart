import "dart:math";

const _chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

extension ExString on String {
  static String random(int length) {
    if (length <= 0) throw Exception("Length must be greater then 0");
    final rnd = Random();
    final value = StringBuffer();
    for (int i = 0; i < length; i++) {
      value.write(_chars[rnd.nextInt(_chars.length)]);
    }
    return value.toString();
  }
}
