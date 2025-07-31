import 'package:flutter/material.dart';
import 'package:music_player/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme(
      displayLarge: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontFamily: 'Roboto'),
      bodyMedium: TextStyle(fontFamily: 'Roboto'),
      bodySmall: TextStyle(fontFamily: 'Roboto'),
    );

    return MaterialApp(
      title: 'Music Player',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade100,
        fontFamily: 'Roboto',
        textTheme: textTheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Roboto',
        textTheme: textTheme.apply(
          bodyColor: Colors.white.withOpacity(0.8),
          displayColor: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}