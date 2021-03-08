import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import 'package:friends_chat/main.dart';
import 'package:friends_chat/widgets/new_message.dart';

class ChatScreen extends StatefulWidget {
  static String route = '/chat';
  final String userid;
  ChatScreen({this.userid});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool showStickerKeyboard = false;
  TextEditingController messageController = TextEditingController();
  FirebaseFirestore firestoreinstance = FirebaseFirestore.instance;
  var box = Hive.box('myBox');

//set important data to local storage
  Future<void> getandsetuserdata() async {
    try {
      var dataSnapshot = await firestoreinstance
          .collection('users')
          .where('UserId', isEqualTo: widget.userid)
          .get();

      dataSnapshot.docs.forEach((element) {
        box.put('ProfilePic', element['ProfilePic']);
        box.put('UserEmail', element['UserEmail']);
        box.put('UserName', element['UserName']);
        box.put('UserDataSet', true);
        // print(element['ProfilePic']);
      });
    } catch (e) {
      print(e.toString());
    }
  }

//send message
  sendMessage(var newMessage) async {
    bool isdataset = box.get('UserDataSet');
    if (isdataset != true) {
      await getandsetuserdata();
    }

    String userid = box.get('userId');
    String userimage = box.get('ProfilePic');
    String username = box.get('UserName');

    try {
      var send = await firestoreinstance.collection('message').add({
        'date': DateTime.now().toIso8601String(),
        'message': newMessage,
        'senderId': userid,
        'senderImage': userimage,
        'senderName': username,
        'type': 'text',
      });
    } catch (e) {
      print(e.toString());
    }
  }

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
            //chat arera
            Expanded(child: Container()),

            //chat message area
            NewMessage(
              showEmoji: showStickerKeyboard,
              messageController: messageController,
              MsgFunction: sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
