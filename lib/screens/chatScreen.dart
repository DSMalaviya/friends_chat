import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:friends_chat/widgets/chat_bubble.dart';
import 'package:hive/hive.dart';

import 'package:friends_chat/main.dart';
import 'package:friends_chat/widgets/new_message.dart';
import 'package:friends_chat/db/chat_operations.dart';

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
  ChatOperations chatoperations = new ChatOperations();
  bool isMe = false;

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
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: StreamBuilder(
                  stream: firestoreinstance.collection('message').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      final chatDocs = snapshot.data.docs;
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: chatDocs.length,
                        itemBuilder: (context, index) {
                          if (chatDocs[index]['senderId'] == widget.userid) {
                            isMe = true;
                          } else {
                            isMe = false;
                          }
                          return MessageBubble(
                            message: chatDocs[index]['message'],
                            senderImgUrl: chatDocs[index]['senderImage'],
                            keyid: chatDocs[index].id,
                            isMe: isMe,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),

            //chat message area
            NewMessage(
              showEmoji: showStickerKeyboard,
              messageController: messageController,
              MsgFunction: chatoperations.sendMessage,
              userid: widget.userid,
            ),
          ],
        ),
      ),
    );
  }
}
