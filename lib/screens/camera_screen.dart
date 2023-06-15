import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nomad/widgets/map/rounded_icon_button.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  bool _isFlashOn = false;
  bool _isBackCamera = true;
  bool _isCameraInitialized = false;
  List<CameraDescription> cameras = [];
  XFile? _capturedImage; // Store the captured image file

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera({
    CameraLensDirection lensDirection = CameraLensDirection.back,
  }) async {
    cameras = await availableCameras();

    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == lensDirection,
    );

    setState(() {
      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.max,
        enableAudio: false,
      );
    });

    try {
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized =
            _cameraController != null && _cameraController!.value.isInitialized;
      });
    } catch (error) {
      // TODO: Handle camera initialization error
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _capturePhoto() async {
    if (!_isCameraInitialized) {
      return;
    }

    final image = await _cameraController!.takePicture();
    // Store the captured image
    setState(() {
      _capturedImage = image;
    });
  }

  Future<void> _toggleCamera() async {
    final lensDirection =
        _isBackCamera ? CameraLensDirection.front : CameraLensDirection.back;

    try {
      setState(() {
        _isCameraInitialized = false;
      });
      await _cameraController?.dispose();
    } catch (e) {
      // TODO: handle error
    }
    _initializeCamera(lensDirection: lensDirection);
    setState(() {
      _isBackCamera = !_isBackCamera;
    });
  }

  void _clearImagePreview() {
    setState(() {
      _capturedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Colors.white,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_isCameraInitialized)
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Center(
                child: Container(
                  color: Colors.black,
                  height: MediaQuery.of(context).size.height,
                  child: SafeArea(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: _capturedImage != null
                          ? CapturedImage(
                              imagePath: _capturedImage!.path,
                              clearImagePreview: _clearImagePreview,
                            )
                          : CameraPreviewWidget(
                              cameraController: _cameraController!,
                              onFlashToggle: () {
                                setState(() {
                                  _isFlashOn = !_isFlashOn;
                                });
                              },
                              onCapturePhoto: _capturePhoto,
                              onCameraToggle: _toggleCamera,
                              isFlashOn: _isFlashOn,
                            ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CameraPreviewWidget extends StatelessWidget {
  final CameraController cameraController;
  final VoidCallback onFlashToggle;
  final VoidCallback onCapturePhoto;
  final VoidCallback onCameraToggle;
  final bool isFlashOn;

  const CameraPreviewWidget({
    Key? key,
    required this.cameraController,
    required this.onFlashToggle,
    required this.onCapturePhoto,
    required this.onCameraToggle,
    required this.isFlashOn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CameraPreview(
      cameraController,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.transparent,
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  isFlashOn ? Iconsax.flash_15 : Iconsax.flash_slash5,
                  color: Colors.white,
                ),
                onPressed: onFlashToggle,
              ),
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.circleDot,
                  color: Colors.white,
                  size: 42.0,
                ),
                onPressed: onCapturePhoto,
              ),
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.rotate,
                  color: Colors.white,
                ),
                onPressed: onCameraToggle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CapturedImage extends StatelessWidget {
  final String imagePath;
  final void Function() clearImagePreview;

  const CapturedImage({
    Key? key,
    required this.imagePath,
    required this.clearImagePreview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //iconbutton X to nullyfy the image
        Image.file(
          height: MediaQuery.of(context).size.height,
          File(imagePath),
          fit: BoxFit.fill,
        ),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: const Icon(
              FontAwesomeIcons.xmark,
              color: Colors.white,
            ),
            onPressed: () {
              clearImagePreview();
            },
          ),
        ),
        // bottom
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RoundedIconButton(
                  iconColor: Colors.white,
                  icon: FontAwesomeIcons.download,
                  containerColor: Colors.black54,
                  label: '',
                  height: 44,
                  width: 44,
                  expanded: false,
                  radius: 30,
                ),
                RoundedIconButton(
                  iconColor: Colors.white,
                  icon: FontAwesomeIcons.circlePlus,
                  foregroundColor: Colors.white,
                  containerColor: Colors.black54,
                  labelColor: Colors.white,
                  label: 'Post',
                  height: 44,
                  width: 44,
                  radius: 30,
                ),
                RoundedIconButton(
                  iconColor: Colors.white,
                  icon: CupertinoIcons.paperplane_fill,
                  foregroundColor: Colors.white,
                  containerColor: Color(0xFF1EA7FD),
                  labelColor: Colors.white,
                  label: 'Send',
                  height: 44,
                  width: 44,
                  radius: 30,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
