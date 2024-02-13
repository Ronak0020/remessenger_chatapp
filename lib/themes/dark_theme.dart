import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    background: const Color.fromARGB(255, 26, 26, 26),
    primary: Colors.grey.shade500,
    secondary: const Color.fromARGB(255, 83, 83, 83),
    tertiary: Colors.black,
    inversePrimary: Colors.grey.shade300,
    shadow: Colors.grey.shade800,
  ),
  fontFamily: 'Montserrat',
  highlightColor: Colors.deepPurple[500]?.withAlpha(190)
);