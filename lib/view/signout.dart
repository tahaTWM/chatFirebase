// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    TextEditingController fullNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
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
            ),
            SizedBox(height: 20),
            Column(
              children: [
                RaisedButton(
                  onPressed: () {},
                  child: Text("sign Up"),
                  padding: EdgeInsets.symmetric(horizontal: 95, vertical: 15),
                  shape: rectangleBorder(),
                ),
                SizedBox(height: 10),
                RaisedButton(
                  onPressed: () {},
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
                      "Sign Up",
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

  signWithGoogle() {}

  forgetPassword() {}

  registerNow() {}
}
