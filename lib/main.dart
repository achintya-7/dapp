import 'package:dapp/screens/election/election_page.dart';
import 'package:flutter/material.dart';
import 'package:dapp/screens/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dapp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(  
          displayMedium: TextStyle(
            color: Colors.black
          )
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.amber)),
        ),
      ),
      home: const HomePage(),
    );
  }
}
