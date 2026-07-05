import 'dart:math';

class IDGenerator {
  //Generate an id from ramdon letters and numbers 10 characters long
  static String generateId({int? length}) {
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    final ramdon = Random.secure();
    return List.generate(
            length ?? 15,
            (_) =>
                chars[ramdon.nextInt(chars.length)])
        .join('');
  }
}