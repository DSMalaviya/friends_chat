import 'package:flutter/material.dart';
import 'package:friends_chat/widgets/emoji_picker.dart';

class NewMessage extends StatefulWidget {
  bool showEmoji;
  TextEditingController messageController;
  String userid;
  Future<void> Function(String message, String userId, String msgType)
      MsgFunction;
  NewMessage(
      {this.showEmoji, this.messageController, this.userid, this.MsgFunction});
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
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
                        // onTap: () {},
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  //send msg function
                  if (widget.messageController.text.trim() == '') {
                    return null;
                  } else {
                    widget.MsgFunction(
                      widget.messageController.text.trim(),
                      widget.userid,
                      "text",
                    );
                    widget.messageController.clear();
                    Focus.of(context).unfocus();
                  }
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
