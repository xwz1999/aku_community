
class TextUtils {
  ///判断空字符串
  ///
  ///white 全空格是否算空字符串
  static bool isEmpty(String str, {bool whiteSpace = false}) {
    if (whiteSpace) {
      return str == null || str.trim().length == 0;
    }
    return str == null || str.length == 0;
  }

  static bool isNotEmpty(String str, {bool whiteSpace = false}) {
    return !isEmpty(str, whiteSpace: whiteSpace);
  }

  static bool verifyPhone(phone) {
    return new RegExp("^^1\\d{10}\$").hasMatch(phone);
  }
}
