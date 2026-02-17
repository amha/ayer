import 'package:flutter/material.dart';
import './ayer_text.dart';

/// App accent color used for primary actions, selected states, and icons.
const Color ayerAccentColor = Color(0xFFD95407);

ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: true,
    textTheme: ayerTextTheme,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ayerAccentColor,
      primary: ayerAccentColor,
    ),
    scaffoldBackgroundColor: const Color(0xffF3F3F3),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xffF3F3F3),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: ayerAccentColor,
      textTheme: ButtonTextTheme.primary,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: ayerAccentColor,
        side: const BorderSide(color: ayerAccentColor),
        textStyle: const TextStyle(
          color: ayerAccentColor,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: ayerAccentColor,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    popupMenuTheme: const PopupMenuThemeData(
      color: Colors.white,
    ),
    dialogBackgroundColor: Colors.white,
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black, width: 1.5),
      ),
    ),
    primaryColor: ayerAccentColor,
    primaryColorDark: Colors.white,
  );
}
