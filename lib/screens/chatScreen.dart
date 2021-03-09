import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:friends_chat/screens/aboutMe.dart';
import 'package:friends_chat/widgets/chat_bubble.dart';
import 'package:friends_chat/widgets/image_bubble.dart';
import 'package:friends_chat/widgets/link_preview.dart';
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
        title: Text("All Chat"),
        centerTitle: true,
      ),
      backgroundColor: Color.fromRGBO(244, 245, 240, 1),

      //navigation drawer

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: EdgeInsets.all(0),
              child: Image(
                image: AssetImage(
                  'assets/images/navdrawer.jpg',
                ),
                fit: BoxFit.cover,
              ),
              // fit: BoxFit.cover,
            ),
            ListTile(
              title: Text(
                "All Chat",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600]),
              ),
              trailing: Icon(
                Icons.group_outlined,
                size: 30,
              ),
              onTap: () {},
            ),
            Divider(
              thickness: 2,
            ),
            ListTile(
              title: Text(
                "LogOut",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600]),
              ),
              trailing: Icon(
                Icons.logout,
                size: 30,
              ),
              onTap: () async {
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
              },
            ),
            Divider(
              thickness: 2,
            ),
            ListTile(
              title: Text(
                "About Me",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600]),
              ),
              trailing: Icon(
                Icons.person,
                size: 30,
              ),
              onTap: () {
                Navigator.of(context).pushNamed(AboutMe.route);
              },
            ),
          ],
        ),
      ),

      //body
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: StreamBuilder(
                  stream: firestoreinstance
                      .collection('message')
                      .orderBy('date', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      final chatDocs = snapshot.data.docs;
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: chatDocs.length,

                        //this shows only latest msgs becuse we fetch data in decendimg order
                        reverse: true,
                        itemBuilder: (context, index) {
                          //check who is sending message
                          if (chatDocs[index]['senderId'] == widget.userid) {
                            isMe = true;
                          } else {
                            isMe = false;
                          }

                          //check message type
                          if (chatDocs[index]['type'] == 'link') {
                            return chatLinkPreview(
                              message: chatDocs[index]['message'],
                              senderImgUrl: chatDocs[index]['senderImage'],
                              keyid: chatDocs[index].id,
                              isMe: isMe,
                              sender: chatDocs[index]['senderName'],
                            );
                          } else if (chatDocs[index]['type'] == 'image') {
                            return ImageBubble(
                              message: chatDocs[index]['message'],
                              senderImgUrl: chatDocs[index]['senderImage'],
                              keyid: chatDocs[index].id,
                              isMe: isMe,
                              sender: chatDocs[index]['senderName'],
                            );
                          } else {
                            return MessageBubble(
                              message: chatDocs[index]['message'],
                              senderImgUrl: chatDocs[index]['senderImage'],
                              keyid: chatDocs[index].id,
                              isMe: isMe,
                              sender: chatDocs[index]['senderName'],
                            );
                          }
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
