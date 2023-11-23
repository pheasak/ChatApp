import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthLog extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  //sign in
  Future<UserCredential> signiwithEmailPass(
    String email,
    String passwords,
  ) async {
    try {
      UserCredential usercredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: passwords);
      firestore.collection('users').doc(usercredential.user!.uid).set({
        'uid': usercredential.user!.uid,
        'email': email,
        'username': usercredential.user
      }, SetOptions(merge: true));
      return usercredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //Sign up
  Future<UserCredential> signupWithEmailpass(
      String email, String passwords, String username) async {
    try {
      UserCredential usercredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: passwords);
      // after creat the user, create a new docment for the user in new collection
      firestore.collection('users').doc(usercredential.user!.uid).set({
        'uid': usercredential.user!.uid,
        'email': email,
        'username': username
      });
      return usercredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign out
  Future<void> signout() async {
    return await FirebaseAuth.instance.signOut();
  }
}
