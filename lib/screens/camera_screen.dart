import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';

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
      // Handle camera initialization error
      print('Camera initialization failed: $error');
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

    // Do something with the captured photo (e.g., save it, display it)
    print('Captured photo: ${image.path}');
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
      // Handle dispose error, if any
      print('Dispose error: $e');
    }
    _initializeCamera(lensDirection: lensDirection);
    setState(() {
      _isBackCamera = !_isBackCamera;
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
                      child: CameraPreview(
                        _cameraController!,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            color: Colors.transparent,
                            height: 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    _isFlashOn
                                        ? Iconsax.flash_15
                                        : Iconsax.flash_slash5,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    // Toggle flash mode
                                    // Implement your flash control logic here
                                    setState(() {
                                      _isFlashOn = !_isFlashOn;
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    FontAwesomeIcons.circleDot,
                                    color: Colors.white,
                                    size: 42.0,
                                  ),
                                  onPressed: _capturePhoto,
                                ),
                                IconButton(
                                  icon: const Icon(
                                    FontAwesomeIcons.rotate,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    await _toggleCamera();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
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
