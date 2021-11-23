// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors, avoid_print, dead_code, prefer_typing_uninitialized_variables, non_constant_identifier_names, curly_braces_in_flow_control_structures, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './/api/databaseFunctions.dart';
import 'package:flutter/material.dart';

class ChatRoomScreen extends StatefulWidget {
  String chatRoomId;
  String resverID;
  ChatRoomScreen(this.chatRoomId, this.resverID);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  var userData;
  String photoUrl;
  String name;
  DataBase dataBase = DataBase();
  TextEditingController chatingController = TextEditingController();
  Stream<QuerySnapshot> querySnapshot;
  ScrollController _scrollController = ScrollController();
  String username;

  @override
  void initState() {
    getUserData();
    getChatMethod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                        padding: EdgeInsets.all(1.2),
                        decoration: BoxDecoration(
                          color: Colors.green,
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
      body: Column(
        children: [
          chatWidget(),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
              alignment: Alignment.bottomCenter,
              child: TextFormField(
                controller: chatingController,
                decoration: InputDecoration(
                  hintText: "typing...",
                  suffixIcon: IconButton(
                    onPressed: () {
                      sendMessage(widget.resverID).then((value) {
                        jump();
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

  Future sendMessage(resverID) async {
    var time = DateFormat('MMM d, yyyy');
    var day = DateFormat('EEEE, hh:mm a');

    String timeNow = time.format(DateTime.now()).toString();
    String dayNow = day.format(DateTime.now()).toString();

    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, dynamic> message = {
      "message": chatingController.text,
      "sendBy": pref.getString("username"),
      "time": timeNow,
      "data": dayNow,
      "timeAsIdForSorting": DateTime.now().millisecondsSinceEpoch
    };
    await dataBase.sendMessage(widget.chatRoomId, message, resverID);
  }

  getChatMethod() async {
    await dataBase.getChats(widget.chatRoomId).then((value) {
      setState(() {
        querySnapshot = value;
      });
    });
  }

  chatWidget() {
    return StreamBuilder(
      stream: querySnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasData)
          Future.delayed(Duration(milliseconds: 300), () => jump());
        return snapshot.hasData
            ? Expanded(
                flex: 8,
                child: ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: snapshot.data.docs.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (snapshot.data.docs.length == 0)
                      return Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Center(
                              child: Text("You didn't\ndo any Chat yet",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 23,
                                      fontWeight: FontWeight.w500))));
                    if (index == snapshot.data.docs.length)
                      return Container(height: 10);
                    var data = snapshot.data.docs[index].data() as Map;
                    return username == data["sendBy"]
                        ? GestureDetector(
                            onLongPress: () async {
                              var doc_ref = await FirebaseFirestore.instance
                                  .collection("ChatRoom")
                                  .doc(widget.chatRoomId)
                                  .collection("chats")
                                  .orderBy("timeAsIdForSorting")
                                  .get();
                              var id = doc_ref.docs[index].id;
                              FirebaseFirestore.instance
                                  .collection("ChatRoom")
                                  .doc(widget.chatRoomId)
                                  .collection("chats")
                                  .doc(id)
                                  .delete();
                            },
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(data["data"],
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(49, 110, 125, 0.7),
                                          fontSize: 13)),
                                  SizedBox(width: 10),
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: Color.fromRGBO(49, 110, 125, 1),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(40),
                                            topRight: Radius.circular(40),
                                            bottomLeft: Radius.circular(40))),
                                    child: Text(data["message"],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 22),
                                        maxLines: 5),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[700],
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(40),
                                          topRight: Radius.circular(40),
                                          bottomRight: Radius.circular(40))),
                                  child: Text(data["message"],
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22)),
                                ),
                                SizedBox(width: 10),
                                Text(data["data"],
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 13),
                                    maxLines: 5)
                              ],
                            ),
                          );
                  },
                ),
              )
            : Expanded(
                flex: 8,
                child: Center(
                    child: Text(
                  "You didn't\ndo any Chat yet",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                  ),
                )),
              );
      },
    );
  }

  jump() async {
    await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut);
  }
}
