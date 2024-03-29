import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/models/message.dart';
import 'package:tiktok_clone/features/inbox/view_models/message_view_model.dart';
import 'package:tiktok_clone/utils.dart';

class ChatDetailScreenArgs {
  final String userId;
  final String userName;
  final bool hasAvatar;

  const ChatDetailScreenArgs({
    required this.userId,
    required this.userName,
    required this.hasAvatar,
  });
}

class ChatDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = "chatDetail";
  static const String routeURL = ":chatRoomId";

  final String chatRoomId;
  final String userId;
  final String userName;
  final bool hasAvatar;

  const ChatDetailScreen({
    super.key,
    required this.chatRoomId,
    required this.userId,
    required this.userName,
    required this.hasAvatar,
  });

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  String _message = "";

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      setState(() {
        _message = _textEditingController.text;
      });
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _onSendPress() {
    if (_message.isNotEmpty) {
      ref.read(messagesProvider.notifier).sendMessage(
            text: _message,
            chatRoomId: widget.chatRoomId,
            otherUserId: widget.userId,
          );
      _textEditingController.clear();
      setState(() {
        _message = "";
      });
    }
  }

  void _onMessageLongPress(MessageModel message) {
    if (isWithin2Minutes(message.createdAt)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete message"),
            content:
                const Text("Are you sure you want to delete this message?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  ref.read(messagesProvider.notifier).deleteMessage(
                      chatRoomId: widget.chatRoomId, message: message);
                  Navigator.pop(context);
                },
                child: const Text("Delete"),
              ),
            ],
          );
        },
      );
    }
  }

  void _unFocus() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(messagesProvider).isLoading;
    final isDark = isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: Sizes.size8,
          leading: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(
                  Sizes.size2,
                ),
                child: CircleAvatar(
                  radius: Sizes.size24,
                  backgroundImage: widget.hasAvatar
                      ? NetworkImage(
                          "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-jrsky723.appspot.com/o/avatars%2F${widget.userId}?alt=media",
                        )
                      : null,
                  child: Text(
                    widget.userName,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: Sizes.size18,
                  height: Sizes.size18,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: Sizes.size3,
                    ),
                  ),
                ),
              )
            ],
          ),
          title: Text(
            widget.userName,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: const Text("Active now"),
          trailing: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.flag,
                size: Sizes.size20,
              ),
              Gaps.h32,
              FaIcon(
                FontAwesomeIcons.ellipsis,
                size: Sizes.size20,
              )
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: _unFocus,
        child: Stack(
          children: [
            ref.watch(chatProvider(widget.chatRoomId)).when(
                  data: (data) {
                    if (data.isEmpty) {
                      return const Center(
                        child: Text("No messages"),
                      );
                    }
                    return ListView.separated(
                      reverse: true,
                      padding: EdgeInsets.only(
                        top: Sizes.size20,
                        left: Sizes.size14,
                        right: Sizes.size14,
                        bottom: MediaQuery.of(context).padding.bottom +
                            Sizes.size96,
                      ),
                      itemBuilder: (context, index) {
                        final message = data[index];
                        final isMine =
                            message.userId == ref.watch(authRepo).user!.uid;
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: isMine
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: isMine
                              ? [
                                  Text(
                                    convertTimeStampToTime(message.createdAt),
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
                                      fontSize: Sizes.size12,
                                    ),
                                  ),
                                  Gaps.h8,
                                  _buildMessageContainer(
                                      isMine, message, context, isLoading),
                                ]
                              : [
                                  _buildMessageContainer(
                                      isMine, message, context, isLoading),
                                  Gaps.h8,
                                  Text(
                                    convertTimeStampToTime(message.createdAt),
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
                                      fontSize: Sizes.size12,
                                    ),
                                  ),
                                ],
                        );
                      },
                      separatorBuilder: (context, index) => Gaps.v10,
                      itemCount: data.length,
                    );
                  },
                  error: (error, stackTrace) => Center(
                    child: Text(
                      error.toString(),
                    ),
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: BottomAppBar(
                color: isDark ? null : Colors.grey.shade200,
                padding: const EdgeInsets.only(
                  left: Sizes.size12,
                  right: Sizes.size12,
                  top: Sizes.size16,
                  bottom: Sizes.size20,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextField(
                        autocorrect: false,
                        controller: _textEditingController,
                        expands: true,
                        minLines: null,
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          hintText: "Send a message...",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                Sizes.size20,
                              ),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor:
                              isDark ? Colors.grey.shade900 : Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: Sizes.size16,
                          ),
                          suffixIcon: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.faceLaugh,
                                color: isDark
                                    ? Colors.grey.shade500
                                    : Colors.grey.shade900,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Gaps.h16,
                    GestureDetector(
                      onTap: isLoading ? null : _onSendPress,
                      child: Container(
                        padding: const EdgeInsets.all(
                          Sizes.size8,
                        ),
                        decoration: BoxDecoration(
                          color: _message.isEmpty
                              ? isDark
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade300
                              : Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: FaIcon(
                          isLoading
                              ? FontAwesomeIcons.hourglass
                              : FontAwesomeIcons.paperPlane,
                          size: Sizes.size20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildMessageContainer(
      bool isMine, MessageModel message, BuildContext context, bool isLoading) {
    return GestureDetector(
      onLongPress: isMine && !message.isDeleted && !isLoading
          ? () => _onMessageLongPress(message)
          : null,
      child: Container(
        padding: const EdgeInsets.all(
          Sizes.size14,
        ),
        decoration: BoxDecoration(
          color: isMine ? Colors.blue : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(
              Sizes.size20,
            ),
            topRight: const Radius.circular(
              Sizes.size20,
            ),
            bottomLeft: Radius.circular(
              isMine ? Sizes.size20 : Sizes.size5,
            ),
            bottomRight: Radius.circular(
              isMine ? Sizes.size5 : Sizes.size20,
            ),
          ),
        ),
        child: Text(
          message.text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: Sizes.size16,
          ),
        ),
      ),
    );
  }
}
