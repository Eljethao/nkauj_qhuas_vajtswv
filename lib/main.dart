import 'package:flutter/material.dart';
import 'package:nkauj_qhuas_vajtswv/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nkauj Qhuas Vajtswv',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'DefagoNotoSansLao'
      ),
      home: const Home(),
    );
  }
}
