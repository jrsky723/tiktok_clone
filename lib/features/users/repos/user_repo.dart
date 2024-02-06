import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> createProfile(UserProfileModel profile) async {
    await _db.collection("users").doc(profile.uid).set(profile.toJson());
  }

  Future<Map<String, dynamic>?> findProfile(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    return doc.data();
  }

  Future<void> uploadAvatar(File file, String fileName) async {
    final fileRef = _storage.ref().child("avatars/$fileName");
    await fileRef.putFile(file, SettableMetadata(contentType: "image/png"));
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).update(data);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchUsers({
    required String name,
    String? lastUid,
  }) async {
    Query<Map<String, dynamic>> query = _db
        .collection("users")
        .where("name", isGreaterThanOrEqualTo: name)
        .where("name", isLessThan: "${name}z")
        .orderBy("name")
        .limit(5);

    if (lastUid != null) {
      final lastDoc = await _db.collection("users").doc(lastUid).get();
      if (lastDoc.exists) {
        query = query.startAfterDocument(lastDoc);
      }
    }

    return query.get();
  }
}

final userRepo = Provider(
  (ref) => UserRepository(),
);
