// ignore_for_file: file_names, prefer_const_constructors, avoid_print, deprecated_member_use, missing_required_param, curly_braces_in_flow_control_structures

import './/api/databaseFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'profile.dart';
import 'search.dart';

class ConversionScreen extends StatefulWidget {
  @override
  _ConversionScreenState createState() => _ConversionScreenState();
}

class _ConversionScreenState extends State<ConversionScreen> {
  @override
  void initState() {
    getChatsRoom();
    super.initState();
  }

  QuerySnapshot querySnapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(54, 57, 63, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(49, 110, 125, 1),
        title: Text("Home Screen"),
        actions: [
          FlatButton.icon(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            },
            icon: Icon(Icons.account_circle_rounded, color: Colors.white),
            label: Text("Profile", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: querySnapshot == null || querySnapshot.size == 0
          ? Center(
              child: Text(
                "You didn't\ndo any Chat yet",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : chatsRoomsWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Search())),
      ),
    );
  }

  getChatsRoom() {
    DataBase dataBase = DataBase();
    dataBase.getChatRooms().then(
      (value) {
        if (value != null)
          setState(() {
            querySnapshot = value;
          });
      },
    );
  }

  chatsRoomsWidget() => ListView.builder(
        itemCount: querySnapshot.docs.length,
        padding: EdgeInsets.symmetric(vertical: 10),
        itemBuilder: (BuildContext context, int index) {
          final data = querySnapshot.docs[index].data() as Map;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () {
                print(data);
              },
              onLongPress: () async {
                FirebaseFirestore.instance
                    .collection("ChatRoom")
                    .doc(data["charRoomId"])
                    .delete();
                await getChatsRoom();
              },
              title: Text(
                data["users"][1],
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                data["charRoomId"],
                style: TextStyle(color: Colors.white),
              ),
              trailing: Text(
                data["chatRoomCreateDate"].toString().split('-')[0].toString() +
                    '\n' +
                    data["chatRoomCreateDate"]
                        .toString()
                        .split('-')[1]
                        .toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      );
}
