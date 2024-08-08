import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primaryContainer: Color.fromRGBO(238, 238, 238, 1) ,
    background: Color.fromRGBO(255, 255, 255, 1),
    primary: Color.fromARGB(255, 0, 0, 0),
    secondary: Color.fromARGB(255, 2, 197, 174),
    shadow: Color.fromARGB(220, 193, 193, 193),
    outline: Color.fromARGB(219, 233, 233, 233),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primaryContainer: Color.fromRGBO(46, 53, 60, 1),
    background: Color.fromRGBO(0, 0, 0, 1),
    primary: Color.fromRGBO(255, 255, 255, 1),
    secondary: Color.fromARGB(255, 2, 197, 174),
    shadow: Color.fromARGB(225, 39, 39, 39),
    outline: Color.fromARGB(200, 91, 91, 91),

  ),
);
