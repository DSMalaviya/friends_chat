import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:friends_chat/screens/chatScreen.dart';
import 'package:hive/hive.dart';

import 'package:friends_chat/screens/register_screen.dart';

class AuthScreen extends StatefulWidget {
  static String route = "/login";
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;

  Future<void> LoginFn(String email, String password) async {
    setState(() {
      isLoading = true;
    });
    FocusScope.of(context).unfocus();
    _formKey.currentState.validate();
    _formKey.currentState.save();

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      print("login sucess");
      String uid = auth.currentUser.uid.toString();

      //use hive insted of shared prefrences
      var box = Hive.box('myBox');
      box.put('userId', uid);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return ChatScreen(
              userid: uid,
            );
          },
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print("error occurd");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.blue],
                // begin: Alignment.topLeft,
                // end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Container(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width * .8,
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Email Address",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 2),
                              ),
                            ),
                            validator: (value) {
                              bool emailValid = RegExp(
                                      r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                  .hasMatch(value);
                              if (emailValid == true) {
                                return null;
                              } else {
                                return 'Please enter valid email address';
                              }
                            },
                            onSaved: (newValue) {
                              email = newValue.trim();
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 2),
                              ),
                            ),
                            validator: (value) {
                              if (value.length <= 6) {
                                return "Password length must greter then 6 characters";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (newValue) {
                              password = newValue.trim();
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          (isLoading == false)
                              ? ElevatedButton.icon(
                                  label: Text("Login"),
                                  icon: Icon(Icons.login),
                                  onPressed: () {
                                    LoginFn(email, password);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.teal,
                                    elevation: 5,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 30),
                                    shape: const BeveledRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                  ),

                                  // child: Text(
                                  //   "Log in",
                                  //   style: TextStyle(fontSize: 15),
                                  // ),
                                )
                              : CircularProgressIndicator(),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .popAndPushNamed(Register.route);
                              },
                              child: Text('Not have an account?'))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
