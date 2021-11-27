// ignore_for_file: file_names, prefer_const_constructors, sized_box_for_whitespace, avoid_print, prefer_const_literals_to_create_immutables

import 'package:chat_app/view/chat_view/conversionScreen.dart';
import 'package:chat_app/view/chat_view/profile.dart';
import 'package:chat_app/view/ui/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'addPost.dart';

class DisplayPost extends StatefulWidget {
  @override
  _DisplayPostState createState() => _DisplayPostState();
}

class _DisplayPostState extends State<DisplayPost> {
  Stream _streamData;
  BlogApis blogApis = BlogApis();
  var userImage;
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
                                onDoubleTap: () {
                                  var id = snapshot.data.docs[index].id;
                                  FirebaseFirestore.instance
                                      .collection("Posts")
                                      .doc(id)
                                      .update({
                                    "favorite": !body["favorite"]
                                  }).catchError((onError) {
                                    print(onError.toString());
                                  });
                                },
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
                                      onTap: () {
                                        var id = snapshot.data.docs[index].id;
                                        FirebaseFirestore.instance
                                            .collection("Posts")
                                            .doc(id)
                                            .update({
                                          "favorite": !body["favorite"]
                                        }).catchError((onError) {
                                          print(onError.toString());
                                        });
                                      },
                                      child: body["favorite"]
                                          ? Icon(
                                              FontAwesomeIcons.solidHeart,
                                              color: Colors.red,
                                              size: 29,
                                            )
                                          : Icon(
                                              FontAwesomeIcons.heart,
                                              size: 29,
                                            ),
                                    ),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Icon(
                                        FontAwesomeIcons.comment,
                                        size: 29,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
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
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.black,
                                indent: 20,
                                endIndent: 20,
                                thickness: 0.7,
                              ),
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
}
