import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

class RegisterForm extends StatefulWidget {
  final Function(
          String username, String email, String password, File pickedimage)
      registerFn;
  final bool isLoading;
  RegisterForm({this.registerFn, this.isLoading});
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final formkey = GlobalKey<FormState>();

  String email;
  String password;
  String username;

  File pickedimage = null;
  final picker = ImagePicker();
  final passwordcontroller = new TextEditingController();

  Future<void> pickImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 480,
        maxWidth: 480);

    setState(() {
      if (pickedFile.path != null) {
        pickedimage = File(pickedFile.path);
        print("image is selected");
      } else {
        Toast.show("No File is selected", context,
            gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 17),
      child: Form(
        key: formkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 100,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 2, color: Colors.black38),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image(
                    image: (pickedimage == null)
                        ? AssetImage(
                            'assets/images/male-placeholder-image.jpeg')
                        : FileImage(pickedimage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              TextButton(
                onPressed: pickImage,
                child: Text("Select Profile Photo"),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "UserName",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2),
                  ),
                ),
                validator: (value) {
                  if (value.length < 6) {
                    return "username must be gt 5 characters";
                  } else {
                    return null;
                  }
                },
                onSaved: (newValue) {
                  username = newValue.trim();
                },
              ),
              SizedBox(
                height: 17,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Email Address",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2),
                  ),
                ),
                validator: (value) {
                  bool emailValid =
                      RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
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
                height: 17,
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
                    return "Password length must be greter then 6 ";
                  } else {
                    return null;
                  }
                },
                controller: passwordcontroller,
                onSaved: (newValue) {
                  password = newValue.trim();
                },
              ),
              SizedBox(
                height: 17,
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Retype Password",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == passwordcontroller.text) {
                    return null;
                  } else {
                    return "both password must be same";
                  }
                },
              ),
              SizedBox(
                height: 17,
              ),
              (widget.isLoading == false)
                  ? ElevatedButton.icon(
                      onPressed: () {
                        formkey.currentState.validate();
                        formkey.currentState.save();
                        widget.registerFn(
                            username, email, password, pickedimage);
                      },
                      icon: Icon(Icons.account_circle_rounded),
                      label: Text("Register"),
                      style: ElevatedButton.styleFrom(
                          elevation: 5,
                          primary: Colors.blueAccent[300],
                          padding: EdgeInsets.symmetric(horizontal: 100)),
                    )
                  : CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
