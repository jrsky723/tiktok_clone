import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/chat_overview_model.dart';
import 'package:tiktok_clone/features/inbox/models/message.dart';
import 'package:tiktok_clone/features/inbox/repos/chat_overview_repo.dart';

class ChatListViewModel extends AsyncNotifier<List<ChatOverviewModel>> {
  late final ChatListRepo _repository;
  List<ChatOverviewModel> _list = [];

  @override
  FutureOr<List<ChatOverviewModel>> build() async {
    _repository = ref.read(chatRoomRepo);
    final user = ref.read(authRepo).user;
    state = const AsyncValue.loading();
    if (user != null) {
      _list = await _fetchChatRooms(user.uid);
    }

    return _list;
  }

  Future<List<ChatOverviewModel>> _fetchChatRooms(String uid) async {
    final result = await _repository.fetchChatRooms(uid);
    final chatRooms = result.docs.map(
      (doc) => ChatOverviewModel.fromJson(
        doc.data(),
      ),
    );
    return chatRooms.toList();
  }

  Future<void> refresh() async {
    final user = ref.read(authRepo).user;
    state = const AsyncValue.loading();
    if (user != null) {
      _list = await _fetchChatRooms(user.uid);
      state = AsyncValue.data(_list);
    }
  }

  Future<void> updateChatList(String chatRoomId, MessageModel message) async {
    state = const AsyncValue.loading();
    _list = _list.map((chatRoom) {
      if (chatRoom.chatRoomId == chatRoomId) {
        chatRoom = chatRoom.copyWith(
          lastMessage: message.text,
          lastMessageAt: message.createdAt,
          lastMessageBy: message.userId,
        );
      }
      return chatRoom;
    }).toList();
    state = AsyncValue.data(_list);
  }
}

final chatListProvider =
    AsyncNotifierProvider<ChatListViewModel, List<ChatOverviewModel>>(
  () => ChatListViewModel(),
);
