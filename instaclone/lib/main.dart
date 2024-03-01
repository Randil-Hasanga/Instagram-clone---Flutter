import 'package:flutter/material.dart';
import 'package:instaclone/pages/login_page.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red,
        ),
      ),
      initialRoute: 'login',
      routes: {
        'register': (context) => RegisterPage(),
        'login': (context) => LoginPage(),
      },
    );
  }
}
