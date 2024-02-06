import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/chat_overview_model.dart';
import 'package:tiktok_clone/features/inbox/models/message.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class MessagesRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendMessage({
    required MessageModel message,
    required String chatRoomId,
    required String otherUserId,
  }) async {
    await _db.collection('chat_rooms').doc(chatRoomId).collection('texts').add(
          message.toJson(),
        );
    await updateChatRoom(chatRoomId: chatRoomId, message: message);
  }

  Future<String> fetchLastMessageId({
    required String chatRoomId,
  }) async {
    final doc = await _db
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('texts')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();
    return doc.docs.first.id;
  }

  Future<void> updateMessage({
    required String chatRoomId,
    required MessageModel message,
  }) async {
    await _db
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('texts')
        .doc(message.messageId)
        .update(
          message.toJson(),
        );
  }

  Future<void> updateChatRoom({
    required String chatRoomId,
    required MessageModel message,
  }) async {
    await _db.collection('chat_rooms').doc(chatRoomId).update(
      {
        'lastMessage': message.text,
        'lastMessageAt': message.createdAt,
        'lastMessageBy': message.userId,
      },
    );
  }

  Future<bool> fetchChatRoomExists({
    required String chatRoomId,
  }) async {
    final doc = await _db.collection('chat_rooms').doc(chatRoomId).get();
    return doc.exists;
  }

  Future<void> createChatRoom({
    required String chatRoomId,
    required String personA,
    required String personB,
  }) async {
    await _db.collection('chat_rooms').doc(chatRoomId).set(
      {
        'personA': personA,
        'personB': personB,
        'lastMessage': '',
        'lastMessageAt': 0,
      },
    );
    final personAProfile = UserProfileModel.fromJson(
      (await _db.collection('users').doc(personA).get()).data()!,
    );
    final personBProfile = UserProfileModel.fromJson(
      (await _db.collection('users').doc(personB).get()).data()!,
    );

    final chatOverViewA = ChatOverviewModel(
      chatRoomId: chatRoomId,
      otherUserId: personB,
      otherUserName: personBProfile.name,
      hasAvatar: personBProfile.hasAvatar,
    );
    final chatOverViewB = ChatOverviewModel(
      chatRoomId: chatRoomId,
      otherUserId: personA,
      otherUserName: personAProfile.name,
      hasAvatar: personAProfile.hasAvatar,
    );
    await _db
        .collection('users')
        .doc(personA)
        .collection('chat_rooms')
        .doc(personB)
        .set(chatOverViewA.toJson());
    await _db
        .collection('users')
        .doc(personB)
        .collection('chat_rooms')
        .doc(personA)
        .set(chatOverViewB.toJson());
  }
}

final messagesRepo = Provider(
  (ref) => MessagesRepo(),
);
