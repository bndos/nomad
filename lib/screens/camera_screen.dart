import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;

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

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );

    _cameraController = CameraController(backCamera, ResolutionPreset.medium);

    try {
      await _cameraController!.initialize();
    } catch (error) {
      // Handle camera initialization error
      print('Camera initialization failed: $error');
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    final image = await _cameraController!.takePicture();

    // Do something with the captured photo (e.g., save it, display it)
    print('Captured photo: ${image.path}');
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_cameraController != null &&
              _cameraController!.value.isInitialized)
            Padding(
              padding: const EdgeInsets.only(top: 28),
              child: Center(
                child: Container(
                  color: Colors.black,
                  height: MediaQuery.of(context).size.height,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CameraPreview(
                      _cameraController!,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          color: Colors.black.withOpacity(0.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.flash_off,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  // Toggle flash mode
                                  // Implement your flash control logic here
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 36.0,
                                ),
                                onPressed: _capturePhoto,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.flip_camera_ios,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  // Switch camera
                                  // Implement your camera switch logic here
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
        ],
      ),
    );
  }
}
