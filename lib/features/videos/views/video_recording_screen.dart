import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/views/video_preview_screen.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_flash_button.dart';

class VideoRecordingScreen extends StatefulWidget {
  static const String routeName = "postVideo";
  static const String routeURL = "/upload";
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _isSelfieMode = false;

  late final bool _noCamera = kIsWeb || (kDebugMode && Platform.isIOS);
  late FlashMode _flashMode;
  late CameraController _cameraController;

  late double _maxZoomLevel, _minZoomLevel;
  double _currentZoomLevel = 0.0;
  final double _zoomStep = 0.05;
  double _lastZoomVerticalPosition = 0.0;

  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final Animation<double> _buttonAnimation = Tween<double>(
    begin: 1.0,
    end: 1.3,
  ).animate(_buttonAnimationController);

  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  Future<void> _initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) return;

    _cameraController = CameraController(
      cameras.length == 1 ? cameras[0] : cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );

    await _cameraController.initialize();
    _maxZoomLevel = await _cameraController.getMaxZoomLevel();
    _minZoomLevel = await _cameraController.getMinZoomLevel();
    _currentZoomLevel = _minZoomLevel;
    await _cameraController.prepareForVideoRecording();
    _flashMode = _cameraController.value.flashMode;

    setState(() {});
  }

  void _showDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission denied"),
        content: const Text(
          "Please allow camera and microphone permissions to record videos.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _initPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;
    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micDenied) {
      _hasPermission = true;
      await _initCamera();
      setState(() {});
    } else {
      _showDeniedDialog();
    }
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await _initCamera();
    setState(() {});
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (!_noCamera) {
      _initPermissions();
    } else {
      {
        setState(() {
          _hasPermission = true;
        });
      }
    }
    WidgetsBinding.instance.addObserver(this);
    _progressAnimationController.addListener(() {
      setState(() {});
    });
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
    });
  }

  Future<void> _startRecording() async {
    if (_cameraController.value.isRecordingVideo) return;
    await _cameraController.startVideoRecording();

    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) return;

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();

    final video = await _cameraController.stopVideoRecording();

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: false,
        ),
      ),
    );
  }

  Future<void> _onPickVideoPressed() async {
    final video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    if (video == null) return;

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: true,
        ),
      ),
    );
  }

  Future<void> _onZoomLevelChanged(LongPressMoveUpdateDetails details) async {
    if (_lastZoomVerticalPosition == 0.0) {
      _lastZoomVerticalPosition = details.globalPosition.dy;
      return;
    }

    final double currentVerticalPosition = details.globalPosition.dy;
    final delta = currentVerticalPosition - _lastZoomVerticalPosition;

    final double newZoomLevel = _currentZoomLevel - delta * _zoomStep;

    if (newZoomLevel < _minZoomLevel || newZoomLevel > _maxZoomLevel) return;

    await _cameraController.setZoomLevel(newZoomLevel);

    _lastZoomVerticalPosition = currentVerticalPosition;
    _currentZoomLevel = newZoomLevel;

    setState(() {});
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    _progressAnimationController.dispose();
    if (!_noCamera) {
      _cameraController.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_noCamera) return;
    if (!_hasPermission) return;
    if (!_cameraController.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      if (!_cameraController.value.isInitialized) return;
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: !_hasPermission
              ? const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Initializing...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Sizes.size20,
                      ),
                    ),
                    Gaps.v20,
                    CircularProgressIndicator(),
                  ],
                )
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!_noCamera && _cameraController.value.isInitialized)
                      CameraPreview(_cameraController),
                    const Positioned(
                      top: Sizes.size40,
                      left: Sizes.size20,
                      child: CloseButton(
                        color: Colors.white,
                      ),
                    ),
                    if (!_noCamera)
                      Positioned(
                        top: Sizes.size20,
                        right: Sizes.size20,
                        child: Column(
                          children: [
                            IconButton(
                              color: Colors.white,
                              onPressed: _toggleSelfieMode,
                              icon: const Icon(
                                Icons.cameraswitch,
                              ),
                            ),
                            Gaps.v10,
                            VideoFlashButton(
                              flashMode: FlashMode.off,
                              icon: Icons.flash_off_rounded,
                              setFlashMode: _setFlashMode,
                              currentFlashMode: _flashMode,
                            ),
                            Gaps.v10,
                            VideoFlashButton(
                              flashMode: FlashMode.always,
                              icon: Icons.flash_on_rounded,
                              setFlashMode: _setFlashMode,
                              currentFlashMode: _flashMode,
                            ),
                            Gaps.v10,
                            VideoFlashButton(
                              flashMode: FlashMode.auto,
                              icon: Icons.flash_auto_rounded,
                              setFlashMode: _setFlashMode,
                              currentFlashMode: _flashMode,
                            ),
                            Gaps.v10,
                            VideoFlashButton(
                              flashMode: FlashMode.torch,
                              icon: Icons.flashlight_on_rounded,
                              setFlashMode: _setFlashMode,
                              currentFlashMode: _flashMode,
                            ),
                          ],
                        ),
                      ),
                    Positioned(
                      width: MediaQuery.of(context).size.width,
                      bottom: Sizes.size40,
                      child: Row(
                        children: [
                          const Spacer(),
                          GestureDetector(
                            onLongPressStart: (detail) => _startRecording(),
                            onTapUp: (detail) => _stopRecording(),
                            onLongPressEnd: (detail) => _stopRecording(),
                            onLongPressMoveUpdate: _onZoomLevelChanged,
                            child: ScaleTransition(
                              scale: _buttonAnimation,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: Sizes.size80 + Sizes.size14,
                                    height: Sizes.size80 + Sizes.size14,
                                    child: CircularProgressIndicator(
                                      color: Colors.red.shade400,
                                      strokeWidth: Sizes.size6,
                                      value: _progressAnimationController.value,
                                    ),
                                  ),
                                  Container(
                                    width: Sizes.size80,
                                    height: Sizes.size80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: IconButton(
                                onPressed: _onPickVideoPressed,
                                icon: const FaIcon(
                                  FontAwesomeIcons.images,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
