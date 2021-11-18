// ignore_for_file: unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> singIn(String email, String password) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      await pref.setString("uid", result.user.uid);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print("the passwors is too weak");
      } else if (e.code == 'email-already-in-use') {
        print("account is already exists");
      }
      return false;
    } catch (e) {
      print(e.toString());
    }
  }

  singInWithGoogle() {}

  singUp() {}

  forgetpassword() {}
}
