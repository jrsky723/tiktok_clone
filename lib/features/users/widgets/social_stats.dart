import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class SocialStats extends StatelessWidget {
  final String text, count;

  const SocialStats({
    super.key,
    required this.text,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: Sizes.size18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: Sizes.size14,
          ),
        ),
      ],
    );
  }
}
