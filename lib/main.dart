import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:instaclone/pages/home_page.dart';
import 'package:instaclone/pages/login_page.dart';
import 'package:instaclone/pages/profile_page.dart';
import 'package:instaclone/pages/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instaclone/services/firebase_services.dart';
import 'firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  GetIt.instance.registerSingleton<FirebaseService>(
    FirebaseService(),
  );
  await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(false);
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
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 5, 73, 175)),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          elevation: 3.0,
          shadowColor: Colors.black,
          backgroundColor: Color.fromARGB(255, 5, 73, 175),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 5, 73, 175),
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.white,          
        ),
      ),
      initialRoute: 'login',
      routes: {
        'register': (context) => RegisterPage(),
        'login': (context) => LoginPage(),
        'home': (context) => HomePage(),
        'profile': (context) => ProfilePage(),
      },
    );
  }
}
