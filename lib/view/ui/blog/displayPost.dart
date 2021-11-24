// ignore_for_file: file_names, prefer_const_constructors, sized_box_for_whitespace, avoid_print, prefer_const_literals_to_create_immutables

import 'package:chat_app/view/chat_view/conversionScreen.dart';
import 'package:chat_app/view/chat_view/profile.dart';
import 'package:chat_app/view/ui/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';

import 'addPost.dart';

class DisplayPost extends StatefulWidget {
  @override
  _DisplayPostState createState() => _DisplayPostState();
}

class _DisplayPostState extends State<DisplayPost> {
  Stream _streamData;
  BlogApis blogApis = BlogApis();

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(54, 57, 63, 1),
      appBar: AppBar(
          title: Text(
            "Blog App",
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
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
              color: Colors.white,
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

                          return Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blueGrey[200],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Blog Title: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              body["title"],
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        PopupMenuButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0))),
                                          icon: Icon(
                                            Icons.more_vert,
                                            size: 25,
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
                                                  var id = snapshot
                                                      .data.docs[index].id;
                                                  FirebaseFirestore.instance
                                                      .collection("Posts")
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser.uid)
                                                      .collection("posts")
                                                      .doc(id)
                                                      .delete();
                                                }
                                                break;
                                            }
                                          },
                                        ),
                                      ],
                                    )),
                                Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.network(body["imageUrl"]),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 5),
                                        child: Text.rich(
                                          TextSpan(
                                            children: <InlineSpan>[
                                              TextSpan(
                                                text: 'Blog Description: ',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text: body["desc"],
                                              ),
                                            ],
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: IconButton(
                                          icon: body["favorite"]
                                              ? Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                )
                                              : Icon(Icons.favorite_border),
                                          onPressed: () {
                                            var id =
                                                snapshot.data.docs[index].id;
                                            FirebaseFirestore.instance
                                                .collection("Posts")
                                                .doc(FirebaseAuth
                                                    .instance.currentUser.uid)
                                                .collection("posts")
                                                .doc(id)
                                                .update({
                                              "favorite": !body["favorite"]
                                            }).catchError((onError) {
                                              print(onError.toString());
                                            });
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("Time: ${body["time"]}"),
                                      Text("Date: ${body["date"]}"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                        "No Post Add yet1",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ));
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
      _streamData = value;
    });
  }
}
