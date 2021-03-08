import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:friends_chat/screens/auth_screen.dart';
import 'package:friends_chat/widgets/registerForm.dart';

class Register extends StatefulWidget {
  static String route = "/register";
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  firebase_storage.FirebaseStorage fbs =
      firebase_storage.FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> register(username, userEmail, userPassword, profilePic) async {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: userEmail, password: userPassword);

      //get user id of authenticared user
      String uid = auth.currentUser.uid.toString();

      //upload user profile pic to firebase storage
      var refurl = fbs.ref('UserProfile/${uid}.png');
      await refurl.putFile(profilePic);

      //get image url
      var profilePicUrl = await refurl.getDownloadURL();

      //add data to the firebase cloud firestore
      var data = await firestore.collection('users').add({
        'UserName': username,
        'UserEmail': userEmail,
        'UserId': uid,
        'ProfilePic': profilePicUrl,
        'Date_of_join': DateTime.now().toIso8601String(),
      });

      Navigator.of(context).popAndPushNamed(AuthScreen.route);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('weak password');
        Toast.show("weak password", context,
            gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
      } else if (e.code == 'email-already-in-use') {
        print('email is already in use');
        Toast.show("email is alrready in use", context,
            gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
      }
    } catch (e) {
      print(e.toString());
      Toast.show(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Register",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white70,
            ),
            onPressed: () {
              Navigator.of(context).popAndPushNamed(AuthScreen.route);
            },
          ),
        ),
        body: RegisterForm(
          registerFn: register,
          isLoading: isLoading,
        ));
  }
}
