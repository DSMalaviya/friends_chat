import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:hive/hive.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

FirebaseFirestore firestoreinstance = FirebaseFirestore.instance;
var box = Hive.box('myBox');
var uuid = Uuid();
ImagePicker picker = ImagePicker();
firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class ChatOperations {
  Future<void> getandsetuserdata({String userid}) async {
    try {
      var dataSnapshot = await firestoreinstance
          .collection('users')
          .where('UserId', isEqualTo: userid)
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

  Future<void> sendMessage(
      String newMessage, String user_id, String msgType) async {
    bool isdataset = box.get('UserDataSet');
    if (isdataset != true) {
      await getandsetuserdata(userid: user_id);
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
        'type': msgType,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> uploadimage(BuildContext ctx, String user_id) async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 400,
        maxWidth: 400);

    if (pickedFile.path != null) {
      File choosedFile = File(pickedFile.path);
      print('image is selected sucessfully');
      print(pickedFile.path);
      try {
        //generate random name and upload to the firestore
        var uploadUrl = storage.ref('files/${uuid.v4()}.png');
        await uploadUrl.putFile(choosedFile);

        //now get download url
        var downloadurl = await uploadUrl.getDownloadURL();

        //now calling the send message functions to do rest of the task
        await sendMessage(downloadurl, user_id, "image");
      } catch (e) {
        print("Something unexpected occured");
      }
    } else {
      Toast.show("No File has been selected", ctx,
          gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
    }
  }
}
