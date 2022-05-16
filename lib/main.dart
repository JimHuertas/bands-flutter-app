import 'package:flutter/material.dart';
import 'package:flutter_advance/pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      home: HomePage(),
      routes: {
        'home': (_) => HomePage()
      },
    );
  }
}