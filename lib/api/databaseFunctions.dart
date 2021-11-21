// ignore_for_file: file_names, avoid_print, invalid_return_type_for_catch_error

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataBase {
  Future getUsersByUserNames(String userName) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .where("name", isEqualTo: userName)
        .get();
  }

  Future getUsersByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .where("email", isEqualTo: email)
        .get();
  }

  setUserData(userMap) {
    FirebaseFirestore.instance
        .collection("Users")
        .add(userMap)
        .catchError((onError) => print(onError.toString()));
  }

  Future getUserData() async {
    Map<String, dynamic> mapRow;
    mapRow = {
      "name": FirebaseAuth.instance.currentUser.displayName,
      "email": FirebaseAuth.instance.currentUser.email,
      "photoUrl": FirebaseAuth.instance.currentUser.photoURL
    };
    return mapRow;
  }

  Future getChatRooms() async {
    return FirebaseFirestore.instance.collection("ChatRoom").snapshots();
  }

  createChatRoom(String charRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(charRoomId)
        .set(chatRoomMap)
        .catchError(
          (onError) => print(onError.toString()),
        );
  }

  Future sendMessage(String chatRoomID, messageMap) async {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomID)
        .collection("chats")
        .add(messageMap)
        .catchError((onError) => print(onError.toString()));
  }

  Future getChats(String chatRoomID) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomID)
        .collection("chats")
        .orderBy("timeAsIdForSorting")
        .snapshots();
  }
}
