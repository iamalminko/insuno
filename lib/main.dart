import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:insuno_m/screens/splash_screen.dart'; // Import async library for Timer

void main() {
  runApp(InsunoApp());
}

class InsunoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Insuno M',
      home: SplashScreen(),
    );
  }
}
