import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatListRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> fetchChatRooms(String userId) {
    return _db.collection('users').doc(userId).collection('chat_rooms').get();
  }
}

final chatRoomRepo = Provider((ref) => ChatListRepo());
