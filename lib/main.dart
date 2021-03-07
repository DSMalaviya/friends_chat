import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:friends_chat/screens/splashScrren.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:friends_chat/screens/auth_screen.dart';
import 'package:friends_chat/screens/chatScreen.dart';
import 'package:friends_chat/screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String uid = '';

  Future<String> getUid() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    uid = sp.getString('userId');
    return uid;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: AuthScreen(),
      home: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Splash();
          } else {
            if (snapshot.hasData) {
              return ChatScreen(userid: snapshot.data.toString());
            } else {
              return AuthScreen();
            }
          }
        },
        future: getUid(),
      ),

      routes: {
        AuthScreen.route: (ctx) => AuthScreen(),
        Register.route: (ctx) => Register(),
        ChatScreen.route: (ctx) => ChatScreen(),
      },
    );
  }
}
