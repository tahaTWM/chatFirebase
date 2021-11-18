import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './view/auth/signin.dart';
import 'package:flutter/material.dart';

import 'view/chat_view/conversionScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String uid;

  @override
  void initState() {
    super.initState();
    getUid();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: uid == null ? SiginScreen() : ConversionScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }

  getUid() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('uid') != null) {
      setState(() {
        uid = pref.getString('uid');
      });
    } else {
      setState(() {
        uid = null;
      });
    }
  }
}
