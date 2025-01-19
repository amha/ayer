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
  );
}
