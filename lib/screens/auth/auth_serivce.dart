import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await _firestore.collection('users').doc(cred.user!.uid).set({
        'email': email,
      });
      return cred.user;
    } catch (e) {
      log("Something went wrong");
    }
    return null;
  }

  Future<String?> getCurrentUserEmail() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final snapshot =
            await _firestore.collection('users').doc(currentUser.uid).get();
        return snapshot.data()?['email'];
      }
    } catch (e) {
      log("Error getting current user email: $e");
    }
    return null;
  }

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log("Something went wrong");
    }
    return null;
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Something went wrong");
    }
  }
}
