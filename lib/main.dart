import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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

  runApp(const TikTokApp());
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TikTok Clone',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.itimTextTheme(),
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
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.grey.shade50,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.grey.shade50,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.itimTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ),
        scaffoldBackgroundColor: Colors.grey.shade900,
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
          surfaceTintColor: Colors.black,
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          shadowColor: Colors.grey.shade900,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.grey.shade800,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
        ),
      ),
      home: const SignUpScreen(),
    );
  }
}
