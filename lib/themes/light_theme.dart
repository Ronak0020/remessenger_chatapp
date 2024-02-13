import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade300,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade200,
    tertiary: Colors.white,
    inversePrimary: Colors.grey.shade900,
    shadow: Colors.grey.shade400,
  ),
  fontFamily: 'Montserrat',
  highlightColor: Colors.deepPurple[400]?.withAlpha(150),
  appBarTheme: AppBarTheme(
    color: Colors.grey.shade200,
  )
);