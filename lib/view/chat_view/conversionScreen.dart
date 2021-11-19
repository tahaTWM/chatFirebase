// ignore_for_file: file_names, prefer_const_constructors, avoid_print, deprecated_member_use

import './/api/databaseFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../api/authFunctions.dart';
import 'package:flutter/material.dart';
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
          IconButton(
              onPressed: () {
                Api api = Api();
                api.signOut(context);
              },
              icon: Icon(Icons.logout_rounded))
        ],
      ),
      body: querySnapshot == null
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
              title: Text(
                data["users"][1],
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                data["charRoomId"],
                style: TextStyle(color: Colors.white),
              ),
              trailing: Column(
                children: [
                  Text(
                    data["chatRoomCreateDate"].toString().split('-')[0],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    data["chatRoomCreateDate"].toString().split('-')[1],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      );
}
