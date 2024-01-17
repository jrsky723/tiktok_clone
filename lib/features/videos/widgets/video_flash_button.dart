import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class VideoFlashButton extends StatelessWidget {
  final IconData icon;
  final FlashMode flashMode;
  final FlashMode currentFlashMode;
  final Function(FlashMode) setFlashMode;

  const VideoFlashButton(
      {super.key,
      required this.flashMode,
      required this.icon,
      required this.setFlashMode,
      required this.currentFlashMode});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color:
          currentFlashMode == flashMode ? Colors.amber.shade300 : Colors.white,
      onPressed: () => setFlashMode(flashMode),
      icon: Icon(
        icon,
      ),
    );
  }
}
