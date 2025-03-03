import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.purple[50],
        appBar: AppBar(
          title: const Text('My Name App'),
          backgroundColor: Colors.deepPurple,
        ),
        body: const Center(
          child: Text(
            'Hanzla shahzad',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
              letterSpacing: 2.0,
              fontFamily: 'Arial',
            ),
          ),
        ),
      ),
    );
  }
}
