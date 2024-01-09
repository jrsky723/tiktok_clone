import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/users/widgets/social_stats.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text("니꼬"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const FaIcon(
                FontAwesomeIcons.gear,
                size: Sizes.size20,
              ),
            )
          ],
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                foregroundImage: NetworkImage(
                  "https://avatars.githubusercontent.com/u/3612017",
                ),
                child: Text("니꼬"),
              ),
              Gaps.v20,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "@니꼬",
                    style: TextStyle(
                      fontSize: Sizes.size18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Gaps.h5,
                  FaIcon(
                    FontAwesomeIcons.solidCircleCheck,
                    color: Colors.blue.shade500,
                    size: Sizes.size16,
                  ),
                ],
              ),
              Gaps.v20,
              SizedBox(
                height: Sizes.size48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SocialStats(
                      text: "Following",
                      count: "37",
                    ),
                    VerticalDivider(
                      color: Colors.grey.shade300,
                      width: Sizes.size32,
                      thickness: Sizes.size1,
                      indent: Sizes.size14,
                      endIndent: Sizes.size14,
                    ),
                    const SocialStats(
                      text: "Followers",
                      count: "10.5M",
                    ),
                    VerticalDivider(
                      color: Colors.grey.shade300,
                      width: Sizes.size32,
                      thickness: Sizes.size1,
                      indent: Sizes.size14,
                      endIndent: Sizes.size14,
                    ),
                    const SocialStats(
                      text: "Likes",
                      count: "149.3M",
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
      physics: const BouncingScrollPhysics(),
    );
  }
}
