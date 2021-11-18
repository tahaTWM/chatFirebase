// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use, avoid_print

import 'package:chat_app/view/chat_view/conversionScreen.dart';

import '../../api/authFunctions.dart';
import 'package:flutter/material.dart';

import 'forgetPassword.dart';
import 'signUp.dart';

class SiginScreen extends StatefulWidget {
  @override
  _SiginScreenState createState() => _SiginScreenState();
}

class _SiginScreenState extends State<SiginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Api api = Api();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(54, 57, 63, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(49, 110, 125, 1),
        title: Text("Sign In Your account"),
      ),
      body: Container(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () => forgetPassword(),
                      child: Text(
                        "Forget Password?",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
            Column(
              children: [
                RaisedButton(
                  onPressed: () => signIn(),
                  child: Text("Sigin In"),
                  padding: EdgeInsets.symmetric(horizontal: 95, vertical: 15),
                  shape: rectangleBorder(),
                ),
                SizedBox(height: 10),
                RaisedButton(
                  onPressed: () => signInWithGoogle(),
                  child: Text("Sign In With Google"),
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
                    "Don't have account? ",
                    style: TextStyle(color: Colors.white),
                  ),
                  InkWell(
                    onTap: () => registerNow(),
                    child: Text(
                      "Register Now",
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

  signIn() => api.singIn(emailController.text, passwordController.text).then(
      (value) => value
          ? Navigator.push(context,
              MaterialPageRoute(builder: (context) => ConversionScreen()))
          : print("login error"));

  signInWithGoogle() => api.signInWithGoogle(context);

  forgetPassword() => Navigator.push(
      context, MaterialPageRoute(builder: (context) => ForgetPassword()));

  registerNow() => Navigator.push(
      context, MaterialPageRoute(builder: (context) => SignUp()));
}
