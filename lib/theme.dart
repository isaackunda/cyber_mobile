import 'package:flutter/material.dart';

const Color cyberRed = Color(0xFFE30613);
const Color cyberBlack = Colors.black;
const Color cyberWhite = Colors.white;

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: cyberRed,
  scaffoldBackgroundColor: cyberWhite,
  appBarTheme: const AppBarTheme(
    backgroundColor: cyberRed,
    foregroundColor: cyberWhite,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: cyberBlack),
    bodyMedium: TextStyle(color: cyberBlack),
    titleLarge: TextStyle(fontWeight: FontWeight.bold, color: cyberRed, fontFamily: 'Poppins'),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: cyberRed,
    foregroundColor: cyberWhite,
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll<Color>(cyberRed),
      foregroundColor: WidgetStatePropertyAll<Color>(cyberWhite),
      textStyle: WidgetStatePropertyAll<TextStyle>(
        TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  ),
  iconTheme: const IconThemeData(color: cyberRed),
  colorScheme: ColorScheme.light(
    primary: cyberRed,
    onPrimary: cyberWhite,
    secondary: cyberBlack,
    onSecondary: cyberWhite,
    surface: cyberWhite,
    onSurface: cyberBlack,
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: cyberRed,
  scaffoldBackgroundColor: Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    backgroundColor: cyberBlack,
    foregroundColor: cyberWhite,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: cyberWhite),
    bodyMedium: TextStyle(color: cyberWhite),
    titleLarge: TextStyle(fontWeight: FontWeight.bold, color: cyberRed, fontFamily: 'Poppins'),
    titleSmall: TextStyle(color: cyberRed, fontSize: 16, fontFamily: 'Poppins'),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: cyberRed,
    foregroundColor: cyberWhite,
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll<Color>(cyberRed),
      foregroundColor: WidgetStatePropertyAll<Color>(cyberWhite),
      textStyle: WidgetStatePropertyAll<TextStyle>(
        TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  ),
  iconTheme: const IconThemeData(color: cyberRed),
  colorScheme: ColorScheme.dark(
    primary: cyberRed,
    onPrimary: cyberWhite,
    secondary: cyberWhite,
    onSecondary: cyberBlack,
    background: Color(0xFF121212),
    onBackground: cyberWhite,
  ),
);
