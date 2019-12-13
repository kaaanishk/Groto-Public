import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:groto/shared/user.dart';

class AuthService {
  final authStreamController = StreamController<User>();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _firebaseUser;
  User _user;

  Future<User> isLoggedIn() async {
    _firebaseUser = await _firebaseAuth.currentUser();
    if (_firebaseUser == null) return null;
    _user = await fetchFromDatabase(id: _firebaseUser.uid);
    return _user;
  }

  Future<User> fetchFromDatabase({@required String id}) async {
    DocumentSnapshot userSnapshot = await Firestore.instance
        .collection('users')
        .document(_firebaseUser.uid)
        .get();
    return User(userSnapshot: userSnapshot);
  }

  Future<void> _createProfile(
      {@required String id, String name, String email}) async {
    try {
      CollectionReference userCollection =
          Firestore.instance.collection('users');
      await userCollection.document(id).setData({
        'name': name,
        'email': email,
        'address': {'firstline': '', 'secondline': '', 'city': ''},
        'phone': ''
      });
    } catch (e) {
      throw e;
    }
  }

  Future<User> loginWithEmail({@required String email, String password}) async {
    try {
      _firebaseUser = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      return fetchFromDatabase(id: _firebaseUser.uid);
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'ERROR_WRONG_PASSWORD':
          throw 'Error: Password is incorrect';
        case 'ERROR_INVALID_EMAIL':
          throw 'Error: Entered email is not valid';
        case 'ERROR_USER_DISABLED':
          throw 'Error: User is disabled (Contact Support)';
        default:
          throw e.code;
      }
    }
  }

  Future<User> createAccount(
      {@required String name, String email, String password}) async {
    try {
      _firebaseUser = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      await _createProfile(id: _firebaseUser.uid, name: name, email: email);
      _user = await fetchFromDatabase(id: _firebaseUser.uid);
      return _user;
    } on PlatformException catch (e) {
      switch (e.code) {
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          throw 'Error: Email already in use';
        case 'ERROR_INVALID_EMAIL':
          throw 'Error: Entered email is not valid';
        case 'ERROR_USER_DISABLED':
          throw 'Error: User is disabled (Contact Support)';
        default:
          throw e.code;
      }
    }
  }

  Future<void> resetPassword({@required email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw e;
    }
  }

  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw e;
    }
  }

  Stream<User> authStatusChanged() {
    _firebaseAuth.onAuthStateChanged.listen((FirebaseUser user) async {
      if (user != null) {
        _user = await fetchFromDatabase(id: user.uid);
      }
      authStreamController.add(_user);
    });
    return authStreamController.stream;
  }
}
