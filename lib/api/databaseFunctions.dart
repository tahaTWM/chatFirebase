// ignore_for_file: file_names, avoid_print, invalid_return_type_for_catch_error

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataBase {
  //worked
  Future getUsersByUserNames(String userName) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .where("name", isEqualTo: userName)
        .get();
  }

  Future getUsersByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection('Users')
        .where("email", isEqualTo: email)
        .get();
  }

  createChatRoom(chatRoomMap) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    FirebaseFirestore.instance
        .collection("Chats")
        .doc(DateTime.now().millisecondsSinceEpoch.toString())
        .set(chatRoomMap)
        .catchError(
          (onError) => print(onError.toString()),
        );
  }

  Future sendMessage(String chatRoomID, messageMap, String resverID) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    FirebaseFirestore.instance
        .collection('Users')
        .doc(pref.getString('uid'))
        .collection(chatRoomID)
        .add(messageMap)
        .catchError((onError) => print(onError.toString()));

    FirebaseFirestore.instance
        .collection('Users')
        .doc(resverID)
        .collection(chatRoomID)
        .add(messageMap)
        .catchError((onError) => print(onError.toString()));
  }

  setUserData(userMap) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    FirebaseFirestore.instance
        .collection('Users')
        .doc(pref.getString('uid'))
        .set(userMap)
        .catchError((onError) => print(onError.toString()));
  }

  Future checkIfChatRoom(String charRoomId) async {
    return await FirebaseFirestore.instance
        .collection('Chats')
        .doc(charRoomId)
        .get();
  }

  // not sure worked

  Future getUserData() async {
    Map<String, dynamic> mapRow;
    mapRow = {
      "name": FirebaseAuth.instance.currentUser.displayName,
      "email": FirebaseAuth.instance.currentUser.email,
      "photoUrl": FirebaseAuth.instance.currentUser.photoURL
    };
    return mapRow;
  }

  Future getChatRooms(String username) async {
    return FirebaseFirestore.instance
        .collection("Chats")
        .where("users", arrayContains: username)
        .snapshots();
  }

  Future getChats(String chatRoomID) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(pref.getString('uid'))
        .collection(chatRoomID)
        .orderBy("timeAsIdForSorting")
        .snapshots();
  }
}
