import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

FirebaseFirestore firestoreinstance = FirebaseFirestore.instance;
var box = Hive.box('myBox');

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
}
