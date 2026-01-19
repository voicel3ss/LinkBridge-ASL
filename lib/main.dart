import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ASLHomePage(),
    );
  }
}

class ASLHomePage extends StatefulWidget {
  const ASLHomePage({super.key});

  @override
  State<ASLHomePage> createState() => _ASLHomePageState();
}

class _ASLHomePageState extends State<ASLHomePage> {
  static const MethodChannel _channel = MethodChannel('asl_channel');

  String detectedLetter = "Waiting for ML…";

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Poll Android ML every 300ms
    _timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      _getASLLetter();
    });
  }

  Future<void> _getASLLetter() async {
    try {
      final result = await _channel.invokeMethod<String>('getASLLetter');
      if (result != null && mounted) {
        setState(() {
          detectedLetter = result;
        });
      }
    } catch (_) {
      // Fail silently if ML not ready
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ASL → Text (MediaPipe)")),
      body: Center(
        child: Text(
          detectedLetter,
          style: const TextStyle(fontSize: 48),
        ),
      ),
    );
  }
}
