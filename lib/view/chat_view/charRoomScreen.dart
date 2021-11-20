// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './/api/databaseFunctions.dart';
import 'package:flutter/material.dart';

class ChatRoomScreen extends StatefulWidget {
  String chatRoomId;
  ChatRoomScreen(this.chatRoomId);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  var userData;
  String photoUrl;
  String name;
  DataBase dataBase = DataBase();
  TextEditingController chatingController = TextEditingController();
  Stream querySnapshot;

  String username;
  @override
  void initState() {
    getUserData();
    dataBase.getChats(widget.chatRoomId).then((value) {
      setState(() {
        querySnapshot = value;
      });
    });
    chatWidget();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(54, 57, 63, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(49, 110, 125, 1),
        title: Text("Chating..."),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                userData == null
                    ? Icon(Icons.account_circle_rounded, color: Colors.white)
                    : Container(
                        width: 30,
                        height: 30,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(500),
                            child: Image.network(
                              photoUrl,
                              fit: BoxFit.cover,
                            )),
                      ),
                SizedBox(width: 6),
                userData == null
                    ? Text("Profile", style: TextStyle(color: Colors.white))
                    : Text(name, style: TextStyle(color: Colors.white)),
              ],
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          querySnapshot != null
              ? chatWidget()
              : Center(
                  child: Text("No Chat", style: TextStyle(color: Colors.white)),
                ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
            alignment: Alignment.bottomCenter,
            child: TextFormField(
              controller: chatingController,
              decoration: InputDecoration(
                hintText: "typing...",
                suffixIcon: IconButton(
                  onPressed: () {
                    sendMessage().then((value) {
                      setState(() {
                        chatingController.clear();
                      });
                    });
                  },
                  icon: Icon(
                    Icons.send_rounded,
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
              cursorColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString("username");
    });
    await dataBase.getUserData().then((value) {
      setState(() {
        userData = value;
        name = userData["name"];
        photoUrl = userData["photoUrl"];
      });
    });
  }

  Future sendMessage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, dynamic> message = {
      "message": chatingController.text,
      "sendBy": pref.getString("username")
    };
    await dataBase.sendMessage(widget.chatRoomId, message);
  }

  chatWidget() {
    return StreamBuilder(
      stream: querySnapshot,
      builder: (context, snapshot) {
        print(snapshot);
        return null;
        // ListView.builder(
        //   itemCount: snapshot.data.documents.lenth,
        //   itemBuilder: (BuildContext context, int index) {
        //     var data = snapshot.data[index].data() as Map;
        //     print(data);
        //     return null;
        //     // return username == data["sendBy"]
        //     //     ? Container(
        //     //         margin: EdgeInsets.all(5),
        //     //         padding: EdgeInsets.all(10),
        //     //         alignment: Alignment.centerRight,
        //     //         decoration: BoxDecoration(
        //     //             color: Colors.grey,
        //     //             borderRadius: BorderRadius.only(
        //     //                 topLeft: Radius.circular(20),
        //     //                 topRight: Radius.circular(20),
        //     //                 bottomLeft: Radius.circular(20))),
        //     //         child: Text(data["message"],
        //     //             style: TextStyle(color: Colors.white)),
        //     //       )
        //     //     : Container(
        //     //         margin: EdgeInsets.all(5),
        //     //         padding: EdgeInsets.all(10),
        //     //         alignment: Alignment.centerLeft,
        //     //         decoration: BoxDecoration(
        //     //             color: Colors.grey[800],
        //     //             borderRadius: BorderRadius.only(
        //     //                 topLeft: Radius.circular(20),
        //     //                 topRight: Radius.circular(20),
        //     //                 bottomRight: Radius.circular(20))),
        //     //         child: Text(data["message"],
        //     //             style: TextStyle(color: Colors.white)),
        //     //       );
        //   },
        // );
      },
    );
  }
}
