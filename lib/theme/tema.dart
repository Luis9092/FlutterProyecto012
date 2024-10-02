import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primaryContainer: Color.fromRGBO(244, 244, 244, 1) ,
    background: Color.fromRGBO(255, 255, 255, 1),
    primary: Color.fromARGB(255, 0, 0, 0),
    secondary: Color.fromARGB(255, 0, 174, 148),
    shadow: Color.fromARGB(220, 169, 169, 169),
    outline: Color.fromARGB(219, 225, 225, 225),
    
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primaryContainer: Color.fromRGBO(15, 32, 29, 1),
    background: Color.fromRGBO(33, 47, 46, 1),
    primary: Color.fromRGBO(255, 255, 255, 1),
    secondary: Color.fromARGB(255, 0, 231, 196),
    shadow: Color.fromARGB(223, 24, 24, 24),
    outline: Color.fromARGB(255, 93, 93, 93),

  ),
);
