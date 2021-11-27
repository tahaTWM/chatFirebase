import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class BlogApis {
  Future dataFetch() async {
    return await FirebaseFirestore.instance
        .collection("Posts")
        .orderBy('orderID', descending: true)
        .snapshots();
  }

  useToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.green[200],
      textColor: Colors.black,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
