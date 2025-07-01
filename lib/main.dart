import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase_training/pages/category/add_category.dart';
import 'package:flutter_firebase_training/pages/home_page.dart';
import 'package:flutter_firebase_training/pages/auth/login_page.dart';
import 'package:flutter_firebase_training/pages/auth/register_page.dart';
import 'package:flutter_firebase_training/pages/product_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      print('===============================User is currently signed out!');
    } else {
      print('===============================User is signed in!');
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          (FirebaseAuth.instance.currentUser != null &&
                  FirebaseAuth.instance.currentUser!.emailVerified)
              ? HomePage()
              : LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/register': (context) => RegisterPage(),
        '/addCategory': (context) => AddCategory(),
        '/product': (context) => ProductPage(),
      },
    );
  }
}
