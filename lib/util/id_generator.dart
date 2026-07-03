import 'dart:math';

class IDGenerator {
  //Generate an id from ramdon letters and numbers 10 characters long
  static String generateId() {
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    return List.generate(
            10,
            (_) =>
                chars[Random().nextInt(chars.length)])
        .join('');
  }
}