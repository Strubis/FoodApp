import 'package:flutter/material.dart';
import 'package:logic_app/core/constants.dart';
import 'package:logic_app/core/theme_app.dart';
import 'package:logic_app/pages/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_TITLE,
      debugShowCheckedModeBanner: false,
      theme: themeApp,
      home: WelcomePage(),
    );
  }
}