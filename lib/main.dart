import 'package:flutter/material.dart';
import 'package:hackathon/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Swiping App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200], // Light grey background
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}

