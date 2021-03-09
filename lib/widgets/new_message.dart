import 'package:flutter/material.dart';

import 'package:friends_chat/widgets/emoji_picker.dart';
import 'package:friends_chat/db/chat_operations.dart';

class NewMessage extends StatefulWidget {
  bool showEmoji;
  TextEditingController messageController;
  String userid;
  Future<void> Function(String message, String userId, String msgType)
      MsgFunction;

  //just try

  NewMessage({
    this.showEmoji,
    this.messageController,
    this.userid,
    this.MsgFunction,
  });
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  ChatOperations chatOperations = new ChatOperations();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 7),
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
                      icon: widget.showEmoji
                          ? Icon(Icons.keyboard)
                          : Icon(Icons.emoji_emotions_outlined),
                      iconSize: 24,
                      color: Colors.grey[600],
                      onPressed: () {
                        setState(() {
                          widget.showEmoji = !widget.showEmoji;
                        });
                      }),
                ],
              ),
              Expanded(
                child: TextField(
                  controller: widget.messageController,
                  decoration: InputDecoration(
                    hintText: "Enter message",
                    border: InputBorder.none,
                  ),
                  // keyboardType: TextInputType.multiline,
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
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[600],
                          ),

                          //this will open dialoag and upload image to firebase
                          onTap: () => showDialog(
                                context: context,
                                //user must tap cancel button to dismiss the dialog
                                barrierDismissible: false,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Image Picker"),
                                    content: Text(
                                        "Do you want to open phone gallary to pick and upload image"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('No')),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            chatOperations.uploadimage(
                                                context, widget.userid);
                                          },
                                          child: Text('Yes')),
                                    ],
                                  );
                                },
                              )),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  //send msg function

                  //in regex the short links are not working
                  // bool isUrl = RegExp(
                  //         r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)')
                  //     .hasMatch(widget.messageController.text.trim());

                  //so use inbuilt dart function
                  bool isUrl = Uri.parse(widget.messageController.text.trim())
                      .isAbsolute;
                  if (widget.messageController.text.trim() == '') {
                    return null;
                  } else if (isUrl == true) {
                    print("link is executed");
                    widget.MsgFunction(
                      widget.messageController.text.trim(),
                      widget.userid,
                      "link",
                    );
                  } else {
                    widget.MsgFunction(
                      widget.messageController.text.trim(),
                      widget.userid,
                      "text",
                    );
                  }
                  widget.messageController.clear();
                },
                child: Icon(
                  Icons.send,
                  size: 20,
                ),
                style: ElevatedButton.styleFrom(
                    shape: CircleBorder(), elevation: 2),
              ),
            ],
          ),
        ),

        //emoji_picker
        //emojis keyboard
        Emojikeyboard(
          showEmoji: widget.showEmoji,
          messageController: widget.messageController,
        ),
      ],
    );
  }
}
