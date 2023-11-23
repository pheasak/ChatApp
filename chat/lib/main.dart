import 'dart:io';

import 'package:chat/controller/authemailpass.dart';
import 'package:chat/view/home_page.dart';
import 'package:chat/view/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: 'AIzaSyBQ9hBecq2ttfNEZ7GjwONQqgxDD7wnNWQ',
              appId: '1:421205243827:android:107eaa34bb81a31c5a3dc6',
              messagingSenderId: '421205243827',
              projectId: 'messageapp-8e41d'))
      : await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    create: (context) => AuthLog(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Homepage();
          } else {
            return Loginchat();
          }
        },
      ),
    );
  }
}
