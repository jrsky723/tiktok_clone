import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark,
  );
  runApp(const TikTokApp());
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TikTok Clone',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(
          0xFFE9435A,
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(
            0xFFE9435A,
          ),
        ),
        splashColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          surfaceTintColor: Colors.white,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          shadowColor: Colors.grey.shade200,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottomAppBarTheme: const BottomAppBarTheme(
          surfaceTintColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
        ),
      ),
      home: const SignUpScreen(),
    );
  }
}
