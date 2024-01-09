import 'package:flutter/material.dart';

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
          floating: true,
          stretch: true,
          pinned: true,
          backgroundColor: Colors.teal,
          collapsedHeight: 80,
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            titlePadding: const EdgeInsets.all(10),
            stretchModes: const [
              StretchMode.zoomBackground,
              StretchMode.blurBackground,
            ],
            background: Image.asset(
              "assets/images/placeholder.jpg",
              fit: BoxFit.cover,
            ),
            title: const Text('Hello!'),
          ),
        ),
        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Container(),
          ),
          itemExtent: 100,
        ),
      ],
      physics: const BouncingScrollPhysics(),
    );
  }
}
