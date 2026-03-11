import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../../camera_view.dart';
import '../../asl/gesture_classifier.dart';

class ASLCameraScreen extends StatefulWidget {
  const ASLCameraScreen({super.key});

  @override
  State<ASLCameraScreen> createState() => _ASLCameraScreenState();
}

class _ASLCameraScreenState extends State<ASLCameraScreen> {
  final GestureClassifier classifier = GestureClassifier();

  String prediction = "Loading model...";
  bool isModelReady = false;

  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  Future<void> _initModel() async {
    try {
      await classifier.loadModel();
      if (!mounted) return;
      setState(() {
        isModelReady = true;
        prediction = "Show a sign";
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        prediction = "Model load failed";
      });
    }
  }

  Future<void> processFrame(CameraImage image) async {
    if (!isModelReady || isProcessing) return;

    isProcessing = true;

    final result = await classifier.predict(image);

    if (mounted) {
      setState(() {
        prediction = result.isEmpty ? prediction : result;
      });
    }

    isProcessing = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ASL Translator"),
        centerTitle: true,
      ),

      body: Stack(
        children: [
          CameraView(onFrame: processFrame),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Text(
                  prediction,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
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