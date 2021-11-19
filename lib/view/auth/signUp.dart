// ignore_for_file: use_key_in_widget_constructors, unnecessary_new, deprecated_member_use, prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:chat_app/api/databaseFunctions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../api/authFunctions.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Api api = Api();
  File _image;
  ImagePicker imagePicker = ImagePicker();
  String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(54, 57, 63, 1),
      appBar: AppBar(
        title: Text("Create New account"),
        backgroundColor: Color.fromRGBO(49, 110, 125, 1),
      ),
      body: Container(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 190,
              height: 190,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white24,
                    offset: Offset(3, 8),
                    blurRadius: 10,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Container(
                // decoration: avatarDecoration,
                // padding: EdgeInsets.all(3),
                child: imageUrl == null
                    ? _image != null
                        ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                image: AssetImage(_image.path),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () => picIamge(),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                              ),
                              child: Center(
                                child: Icon(Icons.add_a_photo),
                              ),
                            ),
                          )
                    : Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: NetworkImage(imageUrl),
                          ),
                        ),
                      ),
              ),
            ),
            TextFormField(
              controller: fullNameController,
              decoration: textFieldInputDecoration("Full Name"),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: textFieldInputDecoration("Email"),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              decoration: textFieldInputDecoration("Password"),
              style: TextStyle(color: Colors.white),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Column(
              children: [
                RaisedButton(
                  onPressed: () => registerNow(),
                  child: Text("sign Up"),
                  padding: EdgeInsets.symmetric(horizontal: 95, vertical: 15),
                  shape: rectangleBorder(),
                ),
                SizedBox(height: 10),
                RaisedButton(
                  onPressed: () => signWithGoogle(),
                  child: Text("Sign Up With Google"),
                  shape: rectangleBorder(),
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Alread have account? ",
                    style: TextStyle(color: Colors.white),
                  ),
                  InkWell(
                    onTap: () => sign(),
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration textFieldInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.white54),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    );
  }

  RoundedRectangleBorder rectangleBorder() => RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30),
      );

  sign() => Navigator.pop(context);

  signWithGoogle() => api.signInWithGoogle(context);

  registerNow() => api
          .singUp(fullNameController.text, emailController.text,
              passwordController.text)
          .then((value) async {
        await uploadImage();
        Map<String, String> userData = {
          "name": fullNameController.text,
          "email": emailController.text,
          "profileImage": imageUrl,
        };
        DataBase dataBase = DataBase();
        dataBase.setUserData(userData);
        Navigator.pop(context);
      });
  //upload image
  Future picIamge() async {
    PickedFile image = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
    });
  }

  Future uploadImage() {
    String imageName = DateTime.now().microsecondsSinceEpoch.toString();
    final Reference storageFilename = FirebaseStorage.instance
        .ref()
        .child("UserProfileImages")
        .child(imageName);
    final UploadTask uploadTask = storageFilename.putFile(_image);
    uploadTask.then((TaskSnapshot taskSnapshot) {
      taskSnapshot.ref.getDownloadURL().then((imageURL) {
        setState(() {
          imageUrl = imageURL;
        });
      });
    }).catchError((e) {
      print(e.toString());
    });
  }
}
