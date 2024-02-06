import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/chat_overview_model.dart';
import 'package:tiktok_clone/features/inbox/view_models/chat_list_view_model.dart';
import 'package:tiktok_clone/features/inbox/views/chat_detail_screen.dart';
import 'package:tiktok_clone/features/inbox/views/search_user_screen.dart';
import 'package:tiktok_clone/utils.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  static const String routeName = "chats";
  static const String routeURL = "/chats";

  const ChatsScreen({super.key});

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen>
    with WidgetsBindingObserver {
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();

  List<ChatOverviewModel> _list = [];

  final Duration _duration = const Duration(
    milliseconds: 500,
  );

  void _onSearchTap() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SearchUserScreen(),
      ),
    );
    _refresh();
  }

  void _refresh() async {
    await ref.read(chatListProvider.notifier).refresh();
  }

  void _deleteItem(int index, ChatOverviewModel chat) {
    if (_key.currentState != null) {
      _key.currentState!.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: Container(
            color: Colors.red,
            child: _makeChatTile(index, chat),
          ),
        ),
        duration: _duration,
      );
      _list.removeAt(index);
    }
  }

  void _onChatTap(ChatOverviewModel chat) async {
    context.pushNamed(
      ChatDetailScreen.routeName,
      params: {
        "chatRoomId": chat.chatRoomId,
      },
      extra: ChatDetailScreenArgs(
        userId: chat.otherUserId,
        userName: chat.otherUserName,
        hasAvatar: chat.hasAvatar,
      ),
    );
  }

  Widget _makeChatTile(
    int index,
    ChatOverviewModel chat,
  ) {
    return ListTile(
      tileColor: chat.lastMessageBy == ref.read(authRepo).user!.uid
          ? Colors.white
          : Colors.grey.shade200,
      hoverColor: Colors.grey.shade300,
      onLongPress: () => _deleteItem(index, chat),
      onTap: () => _onChatTap(chat),
      leading: CircleAvatar(
        radius: 30,
        foregroundImage: chat.hasAvatar
            ? NetworkImage(
                "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-jrsky723.appspot.com/o/avatars%2F${chat.otherUserId}?alt=media",
              )
            : null,
        child: Text(chat.otherUserName),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            chat.otherUserName,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            convertTimeStampToTime(chat.lastMessageAt),
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: Sizes.size12,
            ),
          ),
        ],
      ),
      subtitle: Text(
        chat.lastMessage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text("Direct messages"),
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const FaIcon(
              FontAwesomeIcons.arrowsRotate,
            ),
          ),
          IconButton(
            onPressed: _onSearchTap,
            icon: const FaIcon(
              FontAwesomeIcons.magnifyingGlass,
            ),
          ),
        ],
      ),
      body: ref.watch(chatListProvider).when(
            data: (chatList) {
              _list = chatList;
              return AnimatedList(
                key: _key,
                initialItemCount: chatList.length,
                itemBuilder: (context, index, animation) {
                  return SizeTransition(
                    sizeFactor: animation,
                    child: _makeChatTile(index, chatList[index]),
                  );
                },
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) => Center(
              child: Text("Error: $error"),
            ),
          ),
    );
  }
}
