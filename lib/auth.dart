//auth.dart
import 'package:app2/login_page.dart';
import 'package:app2/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj based on FirebaseUser
  FirebaseUser? _userFromFirebaseUser(User? user) {
    return user != null ? FirebaseUser(user.uid) : null;
  }

  //auth change
  Stream<FirebaseUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //register email and password
  Future register(String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      )
      ;
      User? user = result.user;

      await DatabaseService(user!.uid).updateUserData(username, 'None');
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      print(e.toString());
    }
  }
}