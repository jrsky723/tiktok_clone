import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/main_navigation_screen.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/inbox/views/activity_screen.dart';
import 'package:tiktok_clone/features/inbox/views/chat_detail_screen.dart';
import 'package:tiktok_clone/features/inbox/views/chats_screen.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:tiktok_clone/features/videos/views/video_recording_screen.dart';

final routerProvider = Provider(
  (ref) {
    // ref.watch(authState);
    return GoRouter(
      initialLocation: "/home",
      redirect: (context, state) {
        final isLoggedIn = ref.watch(authRepo).isLoggedIn;
        if (!isLoggedIn) {
          if (state.subloc != SignUpScreen.routeURL &&
              state.subloc != LoginScreen.routeURL &&
              !isLoggedIn) {
            return SignUpScreen.routeURL;
          }
        }
        return null;
      },
      routes: [
        GoRoute(
          name: SignUpScreen.routeName,
          path: SignUpScreen.routeURL,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          name: LoginScreen.routeName,
          path: LoginScreen.routeURL,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          name: InterestsScreen.routeName,
          path: InterestsScreen.routeURL,
          builder: (context, state) => const InterestsScreen(),
        ),
        GoRoute(
          path: "/:tab(home|discover|inbox|profile)",
          name: MainNavigationScreen.routeName,
          builder: (context, state) {
            final String tab = state.params["tab"]!;
            return MainNavigationScreen(tab: tab);
          },
        ),
        GoRoute(
          path: ActivityScreen.routeURL,
          name: ActivityScreen.routeName,
          builder: (context, state) => const ActivityScreen(),
        ),
        GoRoute(
          path: ChatsScreen.routeURL,
          name: ChatsScreen.routeName,
          builder: (context, state) => const ChatsScreen(),
          routes: [
            GoRoute(
              path: ChatDetailScreen.routeURL,
              name: ChatDetailScreen.routeName,
              builder: (context, state) {
                final chatRoomId = state.params["chatRoomId"]!;
                final args = state.extra as ChatDetailScreenArgs;
                return ChatDetailScreen(
                  chatRoomId: chatRoomId,
                  userId: args.userId,
                  userName: args.userName,
                  hasAvatar: args.hasAvatar,
                );
              },
            )
          ],
        ),
        GoRoute(
          path: VideoRecordingScreen.routeURL,
          name: VideoRecordingScreen.routeName,
          pageBuilder: (context, state) => CustomTransitionPage(
            transitionDuration: const Duration(milliseconds: 200),
            child: const VideoRecordingScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              final position =
                  Tween(begin: const Offset(0, 1), end: Offset.zero)
                      .animate(animation);
              return SlideTransition(
                position: position,
                child: child,
              );
            },
          ),
        ),
      ],
    );
  },
);
