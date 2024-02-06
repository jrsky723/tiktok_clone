import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/inbox/views/chat_detail_screen.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/view_models/user_list_view_model.dart';
import 'package:tiktok_clone/utils.dart';

class SearchUserScreen extends ConsumerStatefulWidget {
  const SearchUserScreen({super.key});

  @override
  ConsumerState<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends ConsumerState<SearchUserScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  void _onSubmitted(String value) {
    ref.read(userListProvider.notifier).search(value);
  }

  void _onClearTapped() {
    _textEditingController.clear();
  }

  void _onUserTapped(UserProfileModel user) {
    context.pushNamed(
      ChatDetailScreen.routeName,
      params: {
        "chatRoomId": getChatRoomId(ref.read(authRepo).user!.uid, user.uid),
      },
      extra: ChatDetailScreenArgs(
        userId: user.uid,
        userName: user.name,
        hasAvatar: user.hasAvatar,
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: const Text('Search User'),
            pinned: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(Sizes.size48),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size16,
                  vertical: Sizes.size8,
                ),
                child: TextField(
                  style: TextStyle(
                    color: isDarkMode(context) ? Colors.white : Colors.black,
                  ),
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintText: "Search by Name",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: GestureDetector(
                      onTap: _onClearTapped,
                      child: const Icon(
                        FontAwesomeIcons.solidCircleXmark,
                        color: Colors.grey,
                        size: Sizes.size20,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: isDarkMode(context)
                        ? Colors.grey.shade900
                        : Colors.grey.shade200,
                  ),
                  onSubmitted: _onSubmitted,
                ),
              ),
            ),
          ),
          Consumer(
            builder: (context, ref, child) => ref.watch(userListProvider).when(
                  error: (error, stackTrace) => SliverFillRemaining(
                    child: Center(child: Text("Error: $error")),
                  ),
                  loading: () => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  data: (data) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final user = data[index];
                          return ListTile(
                            leading: CircleAvatar(
                              radius: Sizes.size24,
                              foregroundImage: user.hasAvatar
                                  ? NetworkImage(
                                      "https://firebasestorage.googleapis.com/v0/b/tiktok-clone-jrsky723.appspot.com/o/avatars%2F${user.uid}?alt=media",
                                    )
                                  : null,
                              child: Text(
                                user.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            title: Text(user.name),
                            subtitle: Text(user.bio),
                            onTap: () => _onUserTapped(user),
                          );
                        },
                        childCount: data.length,
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
