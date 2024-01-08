import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_munasaka/app/landing_page.dart';
import 'package:flutter_munasaka/locator.dart';
import 'package:flutter_munasaka/viewmodel/user_viewmodel.dart';
import 'package:provider/provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid ?
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "API-KEY-HERE",
        appId: "APP-ID",
        messagingSenderId: "MESSAGING-ID",
        projectId: "flutter-munasaka",
        storageBucket: "STORAGE-BUCKET"
    ))
      : await Firebase.initializeApp();

  setupLocator();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      /*builder: (context) => FUserModel(),*/
      create: (context) => FUserModel(),
      child: MaterialApp(
        title: 'Münaşaka',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home : LandingPage()),
    );
  }

}