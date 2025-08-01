import 'package:flutter/material.dart';
import 'package:music_player/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold),
          displaySmall: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold),
          headlineLarge: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold),
          displaySmall: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold),
          headlineLarge: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(fontFamily: 'PlaywritePL', fontWeight: FontWeight.bold),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}