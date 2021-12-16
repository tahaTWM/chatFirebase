// ignore_for_file: file_names, prefer_const_constructors, sized_box_for_whitespace, avoid_print, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures

import 'dart:ffi';

import 'package:chat_app/api/databaseFunctions.dart';
import 'package:chat_app/view/chat_view/conversionScreen.dart';
import 'package:chat_app/view/chat_view/profile.dart';
import 'package:chat_app/view/ui/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'addPost.dart';

class DisplayPost extends StatefulWidget {
  @override
  _DisplayPostState createState() => _DisplayPostState();
}

class _DisplayPostState extends State<DisplayPost> {
  Stream _streamData;
  Stream _streamComment;
  BlogApis blogApis = BlogApis();
  var userImage;
  TextEditingController commentController = TextEditingController();
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromRGBO(54, 57, 63, 1),
      appBar: AppBar(
          title: Text(
            "MinGram",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(49, 110, 125, 1),
          iconTheme: IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: Icon(FontAwesomeIcons.facebookMessenger),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConversionScreen()));
              },
              color: Colors.white,
            ),
            userImage == null
                ? IconButton(
                    icon: Icon(Icons.person),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Profile()));
                    },
                    color: Colors.white,
                  )
                : GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Profile()));
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      width: 28,
                      height: 28,
                      padding: EdgeInsets.all(1.2),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(userImage),
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
          ]),
      body: RefreshIndicator(
        onRefresh: () => getData(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder(
              stream: _streamData,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          Map<String, dynamic> body =
                              snapshot.data.docs[index].data() as Map;
                          var id = snapshot.data.docs[index].id;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                leading: Container(
                                  width: 44,
                                  height: 44,
                                  padding: EdgeInsets.all(1.4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(500),
                                      child: Image.network(
                                        body['uploaderInfo']['profileImage'],
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                title: Text(body['uploaderInfo']['name']),
                                subtitle: Text(
                                    body["date"] + ' - ' + body["time"],
                                    overflow: TextOverflow.ellipsis),
                                trailing: PopupMenuButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0))),
                                  icon: Icon(
                                    Icons.more_vert,
                                    size: 20,
                                    // color:  Color.fromRGBO(132, 132, 132, 1),
                                  ),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 1,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            size: 25,
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            "Delete",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: "RubicB",
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                  onSelected: (item) {
                                    switch (item) {
                                      case 1:
                                        {
                                          var id = snapshot.data.docs[index].id;
                                          FirebaseFirestore.instance
                                              .collection("Posts")
                                              .doc(id)
                                              .delete();
                                          // var id = snapshot.data.docs[index].id;
                                          // FirebaseFirestore.instance
                                          //     .collection("Posts")
                                          //     .doc(FirebaseAuth
                                          //         .instance.currentUser.uid)
                                          //     .collection("posts")
                                          //     .doc(id)
                                          //     .delete();
                                        }
                                        break;
                                    }
                                  },
                                ),
                              ),
                              GestureDetector(
                                // onDoubleTap: () {
                                //   var id = snapshot.data.docs[index].id;
                                //   FirebaseFirestore.instance
                                //       .collection("Posts")
                                //       .doc(id)
                                //       .update({
                                //     "favorite": !body["favorite"]
                                //   }).catchError((onError) {
                                //     print(onError.toString());
                                //   });
                                // },
                                child: Center(
                                  child: Image.network(
                                    body["imageUrl"],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 10),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        var id = snapshot.data.docs[index].id;
                                        var userID = FirebaseAuth
                                            .instance.currentUser.uid;
                                        var data = await FirebaseFirestore
                                            .instance
                                            .collection("Posts")
                                            .doc(id)
                                            .get();
                                        var update = FirebaseFirestore.instance
                                            .collection("Posts")
                                            .doc(id);
                                        await update.update({
                                          "favorite":
                                              FieldValue.arrayUnion([userID])
                                        });
                                        print(likes(
                                            snapshot.data.docs[index].id));
                                            
                                        // print(data.data()["favorite"]);
                                      },
                                      child:
                                          // likes(snapshot.data.docs[index].id)
                                          //         .contains(FirebaseAuth
                                          //             .instance.currentUser.uid)
                                          //     ? Icon(
                                          //         FontAwesomeIcons.solidHeart,
                                          //         color: Colors.red,
                                          //         size: 22,
                                          //       )
                                          //     :
                                          Icon(
                                        FontAwesomeIcons.heart,
                                        size: 22,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                        onTap: () async {
                                          await getComments(
                                              snapshot.data.docs[index].id);
                                          _showMyDialog(
                                              snapshot.data.docs[index].id);
                                        },
                                        child: Icon(
                                          FontAwesomeIcons.comment,
                                          size: 22,
                                        )),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      body["desc"],
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              (index + 1) != snapshot.data.docs.length
                                  ? Divider(
                                      color: Colors.black,
                                      indent: 20,
                                      endIndent: 20,
                                      thickness: 0.7,
                                    )
                                  : Container(),
                            ],
                          );
                        },
                      )
                    : Center(child: CircularProgressIndicator());
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 20,
        backgroundColor: Color.fromRGBO(49, 110, 125, 1),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPost()));
        },
        child: Icon(
          Icons.file_upload_outlined,
          color: Colors.white,
        ),
      ),
    );
  }

  getData() async {
    await blogApis.dataFetch().then((value) {
      setState(() {
        _streamData = value;
      });
    });
    setState(() {
      userImage = FirebaseAuth.instance.currentUser.photoURL;
    });
  }

  getComments(var id) async {
    DataBase dataBase = DataBase();
    dataBase.comments(id).then((value) {
      setState(() {
        _streamComment = value;
      });
    });
  }

  Future _showMyDialog(var id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Comments'),
          content: streamOfComments(),
          actions: [
            TextFormField(
              controller: commentController,
              decoration: InputDecoration(
                  hintText: "typing...",
                  suffixIcon: IconButton(
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();

                      var username = pref.getString("username");

                      var time = DateFormat('MMM d, yyyy');
                      var day = DateFormat('EEEE, hh:mm a');

                      String timeNow = time.format(DateTime.now()).toString();
                      String dayNow = day.format(DateTime.now()).toString();
                      DataBase dataBase = DataBase();
                      BlogApis api = BlogApis();
                      Map<String, dynamic> mapComment = {
                        "comment": commentController.text,
                        "commentBy": username,
                        'time': timeNow,
                        'date': dayNow,
                        'orderID': DateTime.now().millisecondsSinceEpoch,
                      };
                      if (commentController.text.isNotEmpty)
                        dataBase.addcomments(mapComment, id);
                      else
                        api.useToast('enter a comment');
                    },
                    icon: Icon(
                      Icons.send_rounded,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                  hintStyle: TextStyle(color: Colors.black),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black))),
              style: TextStyle(color: Colors.black, fontSize: 20),
              cursorColor: Colors.black,
              minLines: 1,
              maxLines: 3,
            )
          ],
        );
      },
    );
  }

  Widget streamOfComments() {
    return StreamBuilder(
      stream: _streamComment,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  itemBuilder: (BuildContext context, int index) {
                    final data = snapshot.data.docs[index].data() as Map;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        // leading: resverPhotoUrl.length == 0
                        //     ? FlutterLogo()
                        //     : Container(
                        //         width: 55,
                        //         height: 55,
                        //         padding: EdgeInsets.all(1.2),
                        //         decoration: BoxDecoration(
                        //           color: Colors.white,
                        //           shape: BoxShape.circle,
                        //         ),
                        //         child: ClipRRect(
                        //             borderRadius:
                        //                 BorderRadius.circular(500),
                        //             child: Image.network(
                        //               resverPhotoUrl,
                        //               fit: BoxFit.cover,
                        //             )),
                        //       ),
                        title: Text(
                          data['comment'],
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: Text(
                          data['commentBy'],
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              )
            : Center(
                child: Text(
                  "No Comments",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
      },
    );
  }

  likes(var id) async {
    var data =
        await FirebaseFirestore.instance.collection("Posts").doc(id).get();
    return data.data()["favorite"];
  }
}
