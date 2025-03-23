import 'package:flutter/material.dart';
import './ayer_text.dart';

ThemeData darkTheme() {
  return ThemeData(
      useMaterial3: true,
      textTheme: ayerTextTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.white,
        brightness: Brightness.dark,
        surface: const Color(0xff1E1E1E),
        onSurface: Colors.white,
        surfaceContainerHighest: const Color(0xff121212),
        onSurfaceVariant: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xff121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xff121212),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.white,
        textTheme: ButtonTextTheme.primary,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xff1E1E1E),
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white),
          textStyle: const TextStyle(
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          textStyle: const TextStyle(
            color: Colors.black,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: Color(0xff1E1E1E),
      ),
      dialogBackgroundColor: const Color(0xff1E1E1E),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color(0xff1E1E1E),
        scrimColor: Colors.black54,
      ),
      navigationDrawerTheme: const NavigationDrawerThemeData(
        backgroundColor: Color(0xff1E1E1E),
        indicatorColor: Colors.white24,
        tileHeight: 56,
      ),
      cardTheme: CardTheme(
        color: const Color(0xff1E1E1E),
        elevation: 2,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: Colors.white,
        textColor: Colors.white,
      ),
      dividerTheme: const DividerThemeData(
        color: Colors.white24,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      primaryColor: Colors.white,
      primaryColorDark: Colors.black);
}
