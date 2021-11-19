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

  setUserData(userMap) {
    FirebaseFirestore.instance
        .collection("Users")
        .add(userMap)
        .catchError((onError) => print(onError.toString()));
  }

  Future getUserData() async {
    return await FirebaseAuth.instance.currentUser.providerData;
  }

  getChatRooms() async {
    return await FirebaseFirestore.instance.collection("ChatRoom").get();
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
}
