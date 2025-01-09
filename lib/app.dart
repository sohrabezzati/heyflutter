import 'dart:io';

import 'package:flutter/material.dart';
import 'package:heyflutter/screens/mobile_home_screen.dart';

import 'screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Hey Flutter",
      home: Platform.isAndroid || Platform.isIOS
          ? const MobileHomeScreen()
          : HomeScreen(),
    );
  }
}
