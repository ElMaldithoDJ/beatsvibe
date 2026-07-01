import 'dart:convert';

class UtfConverterService {
  String convertToUtf8(String value) {
    var latin = latin1.encode(value);
    return utf8.decode(latin);
  }
}
