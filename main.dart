import 'package:chat_mobile/screens/chat_screen.dart';
import 'package:chat_mobile/screens/registration_screen.dart';
import 'package:chat_mobile/screens/signin_screen.dart';
import 'package:chat_mobile/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const WelcomeScreen(),
        routes: {
          SignInScreen.ScreenRoute: (context) => SignInScreen(),
          RegistrationScreen.ScreenRoute: (context) => RegistrationScreen(),
          ChatScreen.ScreenRoute: (context) => ChatScreen(),
        });
  }
}
