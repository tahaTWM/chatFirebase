// ignore_for_file: file_names, missing_required_param, deprecated_member_use, prefer_const_constructors, sized_box_for_whitespace, avoid_print, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:chat_app/view/ui/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File _image;
  TextEditingController descController = TextEditingController();
  ImagePicker imagePicker = ImagePicker();
  bool uploading = false;
  BlogApis api = BlogApis();
  Map userInfo;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Uploading Post..",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(240, 126, 32, 1),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _image == null
                ? GestureDetector(
                    onTap: () => picIamge(),
                    child: Container(
                      width: width,
                      height: 300,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(176, 190, 197, 1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo),
                          SizedBox(width: 5),
                          Text("Add Image"),
                        ],
                      ),
                    ),
                  )
                : Container(child: Image.file(_image)),
            Container(
              width: width - 30,
              child: TextField(
                controller: descController,
                decoration: InputDecoration(hintText: "Blog Description"),
                onSubmitted: (_) => uploadImage(),
              ),
            ),
            SizedBox(height: 20),
            !uploading
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          onPressed: () => uploadImage(),
                          child: Text(
                            "Upload",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Color.fromRGBO(240, 126, 32, 1),
                        )
                      ],
                    ),
                  )
                : CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  picIamge() async {
    PickedFile image = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
    });
  }

  uploadImage() async {
    setState(() {
      uploading = true;
    });
    if (_image == null) {
      await picIamge();
    }
    if (descController.text.isNotEmpty) {
      String imageName = DateTime.now().microsecondsSinceEpoch.toString();
      final Reference storageFilename =
          FirebaseStorage.instance.ref().child("BlogIamges").child(imageName);
      final UploadTask uploadTask = storageFilename.putFile(_image);
      uploadTask.then((TaskSnapshot taskSnapshot) {
        taskSnapshot.ref.getDownloadURL().then((imageURL) {
          uploadImageToFirebase(imageURL);
        });
      }).catchError((e) {
        print(e.toString());
      });
    } else {
      api.useToast("title or Description is Empty");
      setState(() {
        uploading = false;
      });
    }
  }

  uploadImageToFirebase(String imagePath) {
    var time = DateFormat('MMM d, yyyy');
    var day = DateFormat('EEEE, hh:mm a');

    String timeNow = time.format(DateTime.now()).toString();
    String dayNow = day.format(DateTime.now()).toString();

    if (descController.text.isNotEmpty && imagePath.isNotEmpty) {
      FirebaseFirestore.instance.collection('Posts').add({
        'imageUrl': imagePath,
        'desc': descController.text,
        'time': timeNow,
        'date': dayNow,
        'favorite': [],
        'orderID': DateTime.now().millisecondsSinceEpoch,
        'uploaderInfo': userInfo,
      }).then((value) {
        setState(() {
          uploading = false;
        });
        Navigator.pop(context);
      }).catchError((onError) {
        print(onError.toString());
      });
    } else {
      api.useToast("error in Entering Data");
    }
  }

  getUserInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var uid = pref.getString('uid');
    print(uid);
    var user =
        await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    setState(() {
      userInfo = user.data();
    });
    print(userInfo);
  }
}
