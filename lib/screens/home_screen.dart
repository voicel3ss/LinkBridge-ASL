import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'translator_screen.dart';
import 'audio_translator_screen.dart';
import 'education_screen.dart'; // <-- NEW SCREEN
import 'group_captioning_screen.dart'; // <-- GROUP CAPTIONING SCREEN

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 122, 217, 168),
      appBar: AppBar(
        title: const Text("ASL App Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          width: 400,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 60, 120, 88),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                blurRadius: 12,
                color: Colors.black26,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Welcome to ASL Translator",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Text(
                user != null ? "Signed in as: ${user.email}" : "Not signed in",
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 9, 43, 15),
                ),
              ),

              const SizedBox(height: 28),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TranslatorScreen()),
                  );
                },
                icon: const Icon(Icons.pan_tool_alt),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                label: const Text("ASL Camera Translator"),
              ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AudioTranslatorScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.hearing),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                label: const Text("Audio to Text"),
              ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EducationScreen()),
                  );
                },
                icon: const Icon(Icons.school),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                label: const Text("Learn About ASL & Hearing Disabilities"),
              ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GroupCaptioningScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.group),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color.fromARGB(255, 33, 97, 140),
                  foregroundColor: Colors.white,
                ),
                label: const Text("Group Captioning"),
              ),

              const SizedBox(height: 20),

              OutlinedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, "/login");
                },
                icon: const Icon(Icons.logout),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                label: const Text("Sign Out"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
