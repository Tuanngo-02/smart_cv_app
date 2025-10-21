// lib/ui/auth/widgets/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon place holder
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.description, size: 50, color: Colors.blue),
                ),

                const SizedBox(height: 30),

                const Text(
                  'AI-Powered Job Support',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                const Text(
                  'Smart CV evaluation & personalized job matching powered by AI',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    child: const Text('Get Started'),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Join thousands of professionals finding their dream jobs',
                  style: TextStyle(fontSize: 12, color: Colors.black45),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
