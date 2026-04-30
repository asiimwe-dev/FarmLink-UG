import 'package:flutter/material.dart';

class DiagnosticsPage extends StatelessWidget {
  const DiagnosticsPage({super.key}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Camera Diagnostics')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue),
              ),
              child: const Column(
                children: [
                  Icon(Icons.construction, size: 48, color: Colors.blue),
                  SizedBox(height: 16),
                  Text(
                    'Under Construction',
                    style: TextStyle(
                      AppTypography.titleLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'AI-powered plant disease diagnostics using camera technology coming soon.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
