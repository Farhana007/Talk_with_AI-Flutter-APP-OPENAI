import 'package:flutter/material.dart';
import 'package:text_to_speech_app/specch_scree.dart';
import 'colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
        color: bgColor2,
      )),
      home: SpeechToTextAi(),
    );
  }
}
