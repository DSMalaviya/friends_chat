import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:emoji_picker/emoji_picker.dart';

import 'package:friends_chat/main.dart';

class ChatScreen extends StatefulWidget {
  static String route = '/chat';
  final String userid;
  ChatScreen({this.userid});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isShowSticker = false;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                try {
                  FirebaseAuth.instance.signOut();
                  var box = Hive.box('myBox');
                  box.delete('userId');
                  box.clear();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) {
                      return MyApp();
                    },
                  ));
                } catch (e) {
                  print("an error occured");
                }
              })
        ],
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: Container()),
            Container(
              alignment: AlignmentDirectional.topStart,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(width: 2, color: Colors.grey[400])),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                          icon: _isShowSticker
                              ? Icon(Icons.keyboard)
                              : Icon(Icons.emoji_emotions_outlined),
                          iconSize: 24,
                          color: Colors.grey[600],
                          onPressed: () {
                            setState(() {
                              _isShowSticker = !_isShowSticker;
                            });
                          }),
                    ],
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Enter message",
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.multiline,
                      autocorrect: true,
                      cursorColor: Colors.black87,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Material(
                          child: InkWell(
                            child: RotationTransition(
                              turns: const AlwaysStoppedAnimation(45 / 360),
                              child: Icon(
                                Icons.attach_file,
                                color: Colors.grey[600],
                              ),
                            ),
                            onTap: () {},
                          ),
                        ),
                        SizedBox(
                          width: 14,
                        ),
                        Material(
                          child: InkWell(
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[600],
                            ),
                            onTap: () {},
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.send,
                      size: 20,
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(), elevation: 5.0),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
