import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

class PostVideoButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool inverted;

  const PostVideoButton({
    super.key,
    required this.onTap,
    required this.inverted,
  });

  @override
  State<PostVideoButton> createState() => _PostVideoButtonState();
}

class _PostVideoButtonState extends State<PostVideoButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reset();
  }

  void _onTapCancel() {
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: Transform.scale(
        scale: 1 + _controller.value,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: 20,
              child: Container(
                height: 35,
                width: 27,
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff61D4F0),
                  borderRadius: BorderRadius.circular(
                    Sizes.size8,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              child: Container(
                height: 35,
                width: 27,
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.size8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(
                    Sizes.size8,
                  ),
                ),
              ),
            ),
            Container(
              height: 35,
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size12,
              ),
              decoration: BoxDecoration(
                color: !widget.inverted || isDark ? Colors.white : Colors.black,
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    Sizes.size6,
                  ),
                ),
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.plus,
                  color:
                      !widget.inverted || isDark ? Colors.black : Colors.white,
                  size: Sizes.size20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
