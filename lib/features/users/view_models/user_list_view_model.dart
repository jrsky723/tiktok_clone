import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/repos/user_repo.dart';

class UserListViewModel extends AsyncNotifier<List<UserProfileModel>> {
  late final UserRepository _usersRepository;
  late final AuthenticationRepository _authenticationRepository;
  List<UserProfileModel> _list = [];

  @override
  FutureOr<List<UserProfileModel>> build() async {
    _usersRepository = ref.read(userRepo);
    _authenticationRepository = ref.read(authRepo);
    if (_authenticationRepository.isLoggedIn) {
      _list = await _fetchUsers(
        name: "",
        lastUid: null,
      );
    }
    return _list;
  }

  Future<List<UserProfileModel>> _fetchUsers({
    required String name,
    String? lastUid,
  }) async {
    final result = await _usersRepository.fetchUsers(
      name: name,
      lastUid: lastUid,
    );
    final users = result.docs.map(
      (doc) => UserProfileModel.fromJson(
        doc.data(),
      ),
    );
    return users.toList();
  }

  Future<void> fetchNextPage(String name) async {
    final nextPage = await _fetchUsers(
      name: name,
      lastUid: _list.last.uid,
    );
    _list = [..._list, ...nextPage];
    state = AsyncValue.data(_list);
  }

  Future<void> refresh() async {
    _list = [];
    state = AsyncValue.data(_list);
  }

  Future<void> search(String name) async {
    _list = await _fetchUsers(
      name: name,
      lastUid: null,
    );
    state = AsyncValue.data(_list);
  }
}

final userListProvider =
    AsyncNotifierProvider<UserListViewModel, List<UserProfileModel>>(
  () => UserListViewModel(),
);
