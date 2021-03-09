import 'package:flutter/material.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bubble/bubble.dart';

class chatLinkPreview extends StatelessWidget {
  String message;
  bool isMe;
  String sender;
  String senderImgUrl;
  String keyid;

  chatLinkPreview(
      {this.message, this.sender, this.isMe, this.senderImgUrl, this.keyid});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      if (isMe == false)
        Positioned(
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            height: 25,
            width: 25,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: CachedNetworkImage(
                imageUrl: senderImgUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      Row(
        mainAxisAlignment:
            (isMe == true) ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
                left: (isMe == true) ? 0 : 20,
                bottom: 10,
                right: (isMe == true) ? 5 : 0),
            key: ValueKey(keyid),
            width: MediaQuery.of(context).size.width * 0.7,
            child: Bubble(
              nip:
                  (isMe == true) ? BubbleNip.rightBottom : BubbleNip.leftBottom,
              child: (isMe == false)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sender,
                          style: TextStyle(color: Colors.black54, fontSize: 10),
                        ),
                        LinkPreview(
                          text: message,
                          width: MediaQuery.of(context).size.width * .7,
                          key: ValueKey(keyid),
                        ),
                      ],
                    )
                  : LinkPreview(
                      text: message,
                      width: MediaQuery.of(context).size.width * .7,
                      key: ValueKey(keyid),
                    ),
            ),
          )
        ],
      ),
    ]);
  }
}

//first code working but chat bubble is better
// return Stack(children: [
//   if (isMe == false)
//     Positioned(
//       bottom: 5,
//       child: Container(
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//         ),
//         height: 25,
//         width: 25,
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(40),
//           child: CachedNetworkImage(
//             imageUrl: senderImgUrl,
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     ),

//   //Link peiview code
//   Row(
//       mainAxisAlignment:
//           (isMe == true) ? MainAxisAlignment.end : MainAxisAlignment.start,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: Color(0xfff7f7f8),
//             borderRadius: BorderRadius.all(Radius.circular(10)),
//           ),
//           alignment: Alignment(0.0, 0.0),
//           margin: EdgeInsets.only(left: (isMe == true) ? 0 : 27),
//           padding: EdgeInsets.only(
//             bottom: 10,
//           ),
//           child: ClipRRect(
//             borderRadius: const BorderRadius.all(
//               Radius.circular(10),
//             ),
//             child: LinkPreview(
//               text: message,
//               width: MediaQuery.of(context).size.width * .6,
//               key: ValueKey(keyid),
//             ),
//           ),
//         ),
//       ]),
// ]);
