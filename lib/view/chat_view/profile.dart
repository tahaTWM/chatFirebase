// ignore_for_file: prefer_const_constructors

import 'package:chat_app/api/authFunctions.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/api/databaseFunctions.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  DataBase dataBase = DataBase();
  List userData;
  @override
  void initState() {
    searchMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(userData.runtimeType);
    return Scaffold(
      backgroundColor: Color.fromRGBO(54, 57, 63, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(49, 110, 125, 1),
        title: Text("Profile"),
        actions: [
          IconButton(
            onPressed: () {
              Api api = Api();
              api.signOut(context);
            },
            icon: Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                // image: DecorationImage(
                //   fit: BoxFit.cover,
                //   image: NetworkImage(imageUrl),
                // ),
              ),
            )
          ],
        ),
      ),
    );
  }

  searchMethod() {
    dataBase.getUserData().then((value) {
      setState(() {
        userData = value;
      });
    });
  }
}
