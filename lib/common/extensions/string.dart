import "dart:math";

extension StringEx on String {
  static String random(int length) {
    if (length <= 0) throw Exception("Length must be greater then 0");
    final rnd = Random();
    final len = (length * 0.5).ceil();
    final bytes = List<int>.generate(len, (i) => rnd.nextInt(256));
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, "0")).join();
  }
}
