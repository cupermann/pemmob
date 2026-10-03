import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kartu Perkenalan',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Kartu Perkenalan'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.child_care,
                size: 100,
                color: Colors.green,
              ),
              SizedBox(height: 16),
              Text(
                'Muhammad Yusuf Bagus Syafaat',
                style: TextStyle(fontSize: 25),
              ),
              Text('NIM: 20240801041',
                style: TextStyle(fontSize: 24),
              ),
              Text('Jurusan: Teknik Informatika',
                style: TextStyle(fontSize: 24),
              ),
              Text('Hobi: Bermain Game dan Tidur',
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}