import 'package:flutter/material.dart';
import './ayer_text.dart';

ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: true,
    textTheme: ayerTextTheme,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
    scaffoldBackgroundColor: const Color(0xffF2F2F2),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xffF2F2F2),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.black,
      textTheme: ButtonTextTheme.primary,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        textStyle: const TextStyle(
          color: Colors.black,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Colors.black,
        textStyle: const TextStyle(
          color: Colors.white,
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
    primaryColor: Colors.black,
    primaryColorDark: Colors.white,
  );
}
