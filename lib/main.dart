import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  preferences = await SharedPreferences.getInstance();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const HomeScreen(),
    theme: ThemeData(
        textTheme:
            TextTheme(bodySmall: TextStyle(color: Colors.lightGreenAccent)),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.lightGreenAccent),
          floatingLabelAlignment: FloatingLabelAlignment.center,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.black87),
                foregroundColor:
                    MaterialStatePropertyAll(Colors.lightGreenAccent))),
        scaffoldBackgroundColor: Colors.white24,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black87,
            foregroundColor: Colors.lightGreenAccent)),
  ));
}

SharedPreferences? preferences;
