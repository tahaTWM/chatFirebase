// ignore_for_file: prefer_const_constructors, deprecated_member_use, avoid_print, unused_local_variable

import 'package:chat_app/api/databaseFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'conversionScreen.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  QuerySnapshot querySnapshot;
  DataBase dataBase = DataBase();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(54, 57, 63, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(49, 110, 125, 1),
        title: Text("Searching..."),
      ),
      body: Container(
        padding: EdgeInsets.all(27),
        child: Column(
          children: [
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: " Search For Member",
                suffixIcon: IconButton(
                  onPressed: () => searchMethod(),
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                hintStyle: TextStyle(color: Colors.white54),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
              ),
              style: TextStyle(color: Colors.white, fontSize: 22),
              // onChanged: (value) {
              //   setState(() {
              //     searchMethod();
              //   });
              // },
              onFieldSubmitted: (value) => searchMethod(),
              cursorColor: Colors.white,
            ),
            Expanded(
              child: querySnapshot == null
                  ? Center(
                      child: Text(
                        "Nothing Search yet",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  : querySnapshot.size == 0
                      ? Center(
                          child: Text(
                            "Nothing Found",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      : searchWidget(),
            )
          ],
        ),
      ),
    );
  }

  searchMethod() {
    dataBase.getUsersByUserNames(searchController.text).then(
      (value) {
        setState(() {
          querySnapshot = value;
        });
        FocusScope.of(context).unfocus();
      },
    );
  }

  searchWidget() => ListView.builder(
        itemCount: querySnapshot.docs.length,
        padding: EdgeInsets.symmetric(vertical: 10),
        itemBuilder: (BuildContext context, int index) {
          final data = querySnapshot.docs[index].data() as Map;
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              data["name"],
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              data["email"],
              style: TextStyle(color: Colors.white),
            ),
            trailing: RaisedButton(
              onPressed: () async {
                List users = [];
                var time = DateFormat('MMM d, yyyy');
                var day = DateFormat('EEEE, hh:mm a');

                String timeNow = time.format(DateTime.now()).toString();
                String dayNow = day.format(DateTime.now()).toString();

                SharedPreferences pref = await SharedPreferences.getInstance();
                users.add(pref.getString("username"));
                users.add(data["name"]);

                final charRoomId =
                    "${pref.getString("username")}-${data["name"]}";

                Map<String, dynamic> chatRoomMap = {
                  "chatRoomCreateDate": "$timeNow-$dayNow",
                  "charRoomId": charRoomId,
                  "users": users
                };

                await dataBase.createChatRoom(charRoomId, chatRoomMap);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => ConversionScreen()),
                    (route) => false);
              },
              child: Text("Message", style: TextStyle(color: Colors.white)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              color: Colors.blue[300],
            ),
          );
        },
      );
}
