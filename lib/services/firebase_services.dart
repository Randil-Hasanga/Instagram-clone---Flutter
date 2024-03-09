// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// ignore: constant_identifier_names
const String USER_COLLECTION = 'users';
const String POSTS_COLLECTION = 'posts';

class FirebaseService {
  FirebaseService();

  Map? currentUser;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential _userCredencial = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (_userCredencial.user != null) {
        currentUser = await getUserData(uid: _userCredencial.user!.uid);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map?> getUserData({required String uid}) async {
    DocumentSnapshot _doc =
        await _db.collection(USER_COLLECTION).doc(uid).get();

    if (_doc.exists) {
      return _doc.data() as Map?;
    }
  }

  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
    required File image,
  }) async {
    try {
      UserCredential _userCredencial =
          await _auth.createUserWithEmailAndPassword(
              email: email, password: password); // create user

      String _userId =
          _userCredencial.user!.uid; // get user id of newly created user
      String _fileName = Timestamp.now().millisecondsSinceEpoch.toString() +
          p.extension(image
              .path); // create a unique filename for image using timestamp ex : 3849385342373304.png
      UploadTask _task = _storage
          .ref('images/$_userId/$_fileName')
          .putFile(image); // create vairable for upload user image file method

      return _task.then((_snapshot) async {
        String _downloadURL = await _snapshot.ref
            .getDownloadURL(); // get download url for the uploaded imageZz
        await _db.collection(USER_COLLECTION).doc(_userId).set({
          "name": name,
          "email": email,
          "image": _downloadURL,
        }); // set user document for new user
        return true;
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> postImage(File _image) async {
    try {
      String _userId = _auth.currentUser!.uid;
      String _fileName = Timestamp.now().millisecondsSinceEpoch.toString() +
          p.extension(_image.path); // create filename for image

      UploadTask _task = _storage
          .ref('images/$_userId/$_fileName')
          .putFile(_image); // create vairable for post image method

      return _task.then((_snapshot) async {
        String _downloadURL =
            await _snapshot.ref.getDownloadURL(); // get download url
        await _db.collection(POSTS_COLLECTION).add({
          // add image to collection
          'userID': _userId,
          'timestamp': Timestamp.now(),
          'image': _downloadURL,
        });
        return true;
      }); //run _task and get result to _snapshot
    } catch (e) {
      print(e);
      return false;
    }
  }

//get Stram of data from an db collection -- In this case, All the photos in posts collection
  Stream<QuerySnapshot> getLatestPosts() {
    return _db
        .collection(POSTS_COLLECTION)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserPosts() {
    String _userId = _auth.currentUser!.uid;
    return _db
        .collection(POSTS_COLLECTION)
        .where("userID", isEqualTo: _userId)
        .snapshots();
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
