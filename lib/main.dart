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
      displayLarge: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold, color: Colors.blue),
      displayMedium: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold, color: Colors.blue),
      displaySmall: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold, color: Colors.blue),
      headlineLarge: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold, color: Colors.blue),
      headlineMedium: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold, color: Colors.blue),
      headlineSmall: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold, color: Colors.blue),
      titleLarge: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontFamily: 'Roboto'),
      bodyMedium: TextStyle(fontFamily: 'Roboto'),
      bodySmall: TextStyle(fontFamily: 'Roboto'),
    );

    return MaterialApp(
      title: 'Music Player',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
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
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        fontFamily: 'Roboto',
        textTheme: textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.deepPurple,
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