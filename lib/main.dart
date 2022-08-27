import 'package:flutter/material.dart';
import 'package:flutter_advance/pages/home.dart';
import 'package:flutter_advance/pages/status.dart';
import 'package:flutter_advance/services/socket_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bands App',
        initialRoute: 'home',
        home: HomePage(),
        routes: {
          'home': (_) => HomePage(),
          'status': (_) => StatusPage()
        },
      ),
    );
  }
}