// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print

import 'package:book_proj/data/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum SignInResult {
  invalidEmail,
  userNotFound,
  emailAlreadyInUse,
  wrongPassword,
  success,
}

class AuthService {
  AuthService(
      {required FirebaseAuth firebaseAuth,
      required FirebaseFirestore firestore})
      : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  UserOwn? signedUserData;

  bool get isSignedIn => _firebaseAuth.currentUser != null;

  Future<SignInResult> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      if (isSignedIn) {
        await _firebaseAuth.signOut();
      }

      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return SignInResult.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return SignInResult.invalidEmail;
      } else if (e.code == 'email-already-in-use') {
        return SignInResult.emailAlreadyInUse;
      } else if (e.code == 'user-not-found') {
        return SignInResult.userNotFound;
      } else if (e.code == 'wrong-password') {
        return SignInResult.wrongPassword;
      } else {
        print(e);
        rethrow;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      if (isSignedIn) {
        await _firebaseAuth.signOut();
      }

      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException {
      return false;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> signOut() => _firebaseAuth.signOut();

  Future<void> addId(String firstName, String telephone) async {
    if (_firebaseAuth.currentUser != null) {
      String uid = (_firebaseAuth.currentUser!.uid);
      UserOwn user =
          UserOwn(id: '', uid: uid, firstName: firstName, telephone: telephone);
      _firestore.collection('Users').add(user.toMap());
    }
  }

  Future<UserOwn?> signedUser() async {
    String id = _firebaseAuth.currentUser!.uid;
    final users = (await _firestore.collection('Users').orderBy('Id').get());
    final list = (users).docs.map(UserOwn.fromSnapshot).toList();
    UserOwn? user;
    list.forEach((element) {
      if (element.uid == id) user = element;
    });
    signedUserData = user;
    return user;
  }

  UserOwn? getSignedUserData() => signedUserData;
  Stream<bool> get isSignedInStream =>
      _firebaseAuth.userChanges().map((user) => user != null);
}
