import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServiceImpl {
  static AuthServiceImpl _instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthServiceImpl._internal();

  static AuthServiceImpl getState() {
    if (_instance == null) {
      _instance = AuthServiceImpl._internal();
    }

    return _instance;
  }

  Future<FirebaseUser> authenticateUser(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<FirebaseUser> registerUser(String email, String password) async {
    return _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
    );
  }
}
