import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:friends_chat/screens/aboutMe.dart';
import 'package:friends_chat/screens/splashScrren.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:friends_chat/screens/auth_screen.dart';
import 'package:friends_chat/screens/chatScreen.dart';
import 'package:friends_chat/screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  userid() async {
    await Hive.openBox('myBox');
    var box = Hive.box('myBox');
    String userid = box.get('userId');
    return userid;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FRIENDS CHAT',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.amber,
      ),
      // home: AuthScreen(),
      home: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Splash();
          } else {
            if (snapshot.hasData) {
              // print(snapshot.data);
              return ChatScreen(userid: snapshot.data);
            } else {
              return AuthScreen();
            }
          }
        },
        future: userid(),
      ),

      routes: {
        AuthScreen.route: (ctx) => AuthScreen(),
        Register.route: (ctx) => Register(),
        ChatScreen.route: (ctx) => ChatScreen(),
        AboutMe.route: (ctx) => AboutMe(),
      },
    );
  }
}
