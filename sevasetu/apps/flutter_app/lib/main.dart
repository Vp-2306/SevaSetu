import 'package:flutter/material.dart';

void main() {
  runApp(const SevaSetuApp());
}

class SevaSetuApp extends StatelessWidget {
  const SevaSetuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SevaSetu',
      home: Scaffold(
        appBar: AppBar(title: const Text('SevaSetu')),
        body: const Center(child: Text('Welcome to SevaSetu')),
      ),
    );
  }
}
