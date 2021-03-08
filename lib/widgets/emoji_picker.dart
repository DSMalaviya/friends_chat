import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';

class Emojikeyboard extends StatefulWidget {
  bool showEmoji;
  TextEditingController messageController;
  Emojikeyboard({this.showEmoji, this.messageController});
  @override
  _EmojikeyboardState createState() => _EmojikeyboardState();
}

class _EmojikeyboardState extends State<Emojikeyboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: (widget.showEmoji == false) ? 0 : 250,
      child: EmojiPicker(
        rows: 3,
        columns: 7,
        onEmojiSelected: (emoji, category) {
          widget.messageController.text =
              widget.messageController.text + emoji.emoji;
        },
      ),
    );
  }
}
