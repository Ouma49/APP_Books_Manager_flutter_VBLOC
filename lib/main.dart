import 'package:flutter/material.dart';
import 'package:books_manager/pages/home.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Finder',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, // You can choose a suitable theme color
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(), // Set HomePage as the initial screen
    );
  }
}
