import 'package:flutter/material.dart';

class AppTheme {
  static Color primaryColor = const Color.fromARGB(255, 30, 101, 255);
  static Color secondaryColor = const Color.fromARGB(255, 30, 120, 255);
  static Color lightBackgroundColor = const Color(0xffFAFAFA);
  static Color darkBackgroundColor = const Color.fromARGB(255, 29, 29, 29);
  static Color lightTextColor = const Color(0xff212121);
  static Color darkTextColor = const Color(0xffFAFAFA);
  static Color lightBorderInputColor = const Color.fromARGB(255, 240, 240, 240);
  static Color darkBorderInputColor = const Color.fromARGB(255, 34, 34, 34);
  static Color playerDarkBgColor = const Color.fromARGB(255, 43, 43, 43);
  static Color playerLightBgColor = const Color.fromARGB(255, 250, 250, 250);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    shadowColor: darkBackgroundColor.withValues(alpha: .3),
    scaffoldBackgroundColor: lightBackgroundColor,
    primaryColor: primaryColor,
    appBarTheme: AppBarTheme(
      backgroundColor: lightBackgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: lightTextColor),
      titleTextStyle: TextStyle(color: lightTextColor, fontSize: 20),
    ),
    textTheme: TextTheme(
      titleMedium: TextStyle(
        color: lightTextColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        color: lightTextColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodyLarge: TextStyle(
        color: lightTextColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: TextStyle(
        color: lightTextColor,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      titleSmall: TextStyle(
        color: lightTextColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: TextStyle(
        color: lightTextColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        color: lightTextColor,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      titleLarge: TextStyle(
        color: lightTextColor,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      headlineLarge: TextStyle(
        color: lightTextColor,
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
      headlineMedium: TextStyle(
        color: lightTextColor,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: TextStyle(
        color: lightTextColor,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.transparent, width: 0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: primaryColor),
      ),
      contentPadding: EdgeInsets.zero,
      filled: true,
      fillColor: lightBorderInputColor,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    shadowColor: Colors.grey.withValues(alpha: .3),
    scaffoldBackgroundColor: darkBackgroundColor,
    primaryColor: primaryColor,
    appBarTheme: AppBarTheme(
      backgroundColor: darkBackgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: darkTextColor),
      titleTextStyle: TextStyle(color: darkTextColor, fontSize: 20),
    ),
    textTheme: TextTheme(
      titleMedium: TextStyle(
        color: darkTextColor,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        color: darkTextColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodyLarge: TextStyle(
        color: darkTextColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: TextStyle(
        color: darkTextColor,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      titleSmall: TextStyle(
        color: darkTextColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelLarge: TextStyle(
        color: darkTextColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        color: darkTextColor,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      titleLarge: TextStyle(
        color: darkTextColor,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      headlineLarge: TextStyle(
        color: darkTextColor,
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
      headlineMedium: TextStyle(
        color: darkTextColor,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: TextStyle(
        color: darkTextColor,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.transparent, width: 0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: primaryColor),
      ),
      contentPadding: EdgeInsets.zero,
      filled: true,
      fillColor: darkBorderInputColor,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        foregroundColor: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        foregroundColor: Colors.white,
      ),
    ),
  );
}
