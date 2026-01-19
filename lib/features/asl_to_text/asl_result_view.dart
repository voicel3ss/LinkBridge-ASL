import 'package:flutter/material.dart';

class ASLResultView extends StatelessWidget {
  final String translatedText;

  const ASLResultView({super.key, required this.translatedText});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        translatedText,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}
