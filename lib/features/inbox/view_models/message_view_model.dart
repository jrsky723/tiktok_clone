import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/message.dart';
import 'package:tiktok_clone/features/inbox/repos/messages_repo.dart';
import 'package:tiktok_clone/features/inbox/view_models/chat_list_view_model.dart';

class MessagesViewModel extends AsyncNotifier<void> {
  late final MessagesRepo _repo;

  @override
  FutureOr<void> build() {
    _repo = ref.read(messagesRepo);
  }

  Future<void> sendMessage({
    required String text,
    required String chatRoomId,
    required String otherUserId,
  }) async {
    final user = ref.read(authRepo).user;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      if (!await _repo.fetchChatRoomExists(chatRoomId: chatRoomId)) {
        await _repo.createChatRoom(
          chatRoomId: chatRoomId,
          personA: user!.uid,
          personB: otherUserId,
        );
      }
      final message = MessageModel(
        text: text,
        userId: user!.uid,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );
      await _repo.sendMessage(
        chatRoomId: chatRoomId,
        message: message,
        otherUserId: user.uid,
      );
      await ref
          .read(chatListProvider.notifier)
          .updateChatList(chatRoomId, message);
    });
  }

  Future<void> deleteMessage({
    required String chatRoomId,
    required MessageModel message,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      message = message.copyWith(isDeleted: true, text: '[Deleted Message]');
      await _repo.updateMessage(chatRoomId: chatRoomId, message: message);

      final lastMessageId =
          await _repo.fetchLastMessageId(chatRoomId: chatRoomId);
      if (lastMessageId == message.messageId) {
        await _repo.updateChatRoom(
          chatRoomId: chatRoomId,
          message: message,
        );
        await ref
            .read(chatListProvider.notifier)
            .updateChatList(chatRoomId, message);
      }
    });
  }
}

final messagesProvider = AsyncNotifierProvider<MessagesViewModel, void>(
  () => MessagesViewModel(),
);

final chatProvider = StreamProvider.autoDispose
    .family<List<MessageModel>, String>((ref, chatRoomId) {
  final db = FirebaseFirestore.instance;
  return db
      .collection('chat_rooms')
      .doc(chatRoomId)
      .collection('texts')
      .orderBy('createdAt')
      .snapshots()
      .map(
        (event) => event.docs
            .map(
              (doc) {
                final message = MessageModel.fromJson(
                  doc.data(),
                );

                return message.copyWith(messageId: doc.id);
              },
            )
            .toList()
            .reversed
            .toList(),
      );
});
