import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

class VideosRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadTask uploadVideoFile(File video, String uid) {
    final fileRef = _storage.ref().child(
        "/videos/$uid/${DateTime.now().microsecondsSinceEpoch.toString()}");
    return fileRef.putFile(
      video,
      SettableMetadata(contentType: "video/mp4"),
    );
  }

  Future<void> saveVideo(VideoModel data) async {
    await _db.collection("videos").add(data.toJson());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos({
    int? lastItemCreatedAt,
  }) {
    final query = _db
        .collection("videos")
        .orderBy("createdAt", descending: true)
        .limit(2);
    if (lastItemCreatedAt == null) {
      return query.get();
    } else {
      return query.startAfter([lastItemCreatedAt]).get();
    }
  }

  Future<DocumentSnapshot> _fetchLike(String videoId, String userId) async =>
      await _db.collection("likes").doc("${videoId}000$userId").get();

  Future<void> toggleLikeVideo(String videoId, String userId) async {
    final like = await _fetchLike(videoId, userId);
    if (like.exists) {
      await like.reference.delete();
    } else {
      await like.reference.set({
        "createdAt": DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  Future<bool> isLikedVideo(String videoId, String userId) async =>
      await _fetchLike(videoId, userId).then((value) => value.exists);
}

final videosRepo = Provider((ref) => VideosRepository());
