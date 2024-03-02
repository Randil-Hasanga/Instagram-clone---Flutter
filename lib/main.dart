import 'package:flutter/material.dart';
import 'package:instaclone/pages/home_page.dart';
import 'package:instaclone/pages/login_page.dart';
import 'package:instaclone/pages/profile_page.dart';
import 'package:instaclone/pages/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InstaClone',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 149, 123, 219),
        ),
      ),
      initialRoute: 'home',
      routes: {
        'register': (context) => RegisterPage(),
        'login': (context) => LoginPage(),
        'home' :(context) => HomePage(),
        'profile':(context) => ProfilePage(),
      },
    );
  }

  
}
