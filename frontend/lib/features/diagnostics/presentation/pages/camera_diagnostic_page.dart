import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:farmlink_ug/core/theme/app_colors.dart';
import 'package:farmlink_ug/core/theme/spacing_constants.dart';
import 'package:farmlink_ug/core/presentation/widgets/ui_refinement_kit.dart';
import 'package:farmlink_ug/core/presentation/widgets/farmlink_card.dart';
import 'package:farmlink_ug/core/presentation/widgets/farmlink_button.dart';

class CameraDiagnosticPage extends StatefulWidget {
  const CameraDiagnosticPage({super.key});

  @override
  State<CameraDiagnosticPage> createState() => _CameraDiagnosticPageState();
}

class _CameraDiagnosticPageState extends State<CameraDiagnosticPage> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  bool _isAnalyzing = false;

  Future<void> _captureImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
        _analyzeImage();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
        _analyzeImage();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _analyzeImage() async {
    setState(() {
      _isAnalyzing = true;
    });

    // Simulate AI analysis
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isAnalyzing = false;
    });

    if (mounted) {
      _showAnalysisResults();
    }
  }

  void _showAnalysisResults() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color ?? Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 24),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Analysis Complete',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Identified Issue:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.grey500),
            ),
            const SizedBox(height: 4),
            const Text(
              'Coffee Leaf Rust (Puccinia triticina)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Confidence: 87%',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primaryDark),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Recommended Treatment:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            _buildRecommendationItem('Apply approved copper-based fungicide'),
            _buildRecommendationItem('Prune affected leaves and destroy them'),
            _buildRecommendationItem('Ensure proper plant spacing for air flow'),
            _buildRecommendationItem('Monitor soil moisture levels'),
            const SizedBox(height: 40),
            FarmLinkButton(
              label: 'Save to Farm Records',
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Diagnosis saved successfully!')),
                );
              },
              icon: Icons.save_rounded,
            ),
            const SizedBox(height: 12),
            FarmLinkButton(
              label: 'Talk to Expert',
              variant: FarmLinkButtonVariant.outline,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icons.support_agent_rounded,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.arrow_right_rounded, color: AppColors.primary),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Diagnostics', style: TextStyle(fontWeight: FontWeight.w900)),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_selectedImage != null)
              FarmLinkCard(
                padding: EdgeInsets.zero,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(_selectedImage!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            else
              FarmLinkCard(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_rounded, size: 64, color: AppColors.primary),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Capture crop image',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'AI will identify diseases and remedies',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: AppColors.grey500, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: FarmLinkButton(
                    label: 'Take Photo',
                    onPressed: _isAnalyzing ? null : _captureImage,
                    icon: Icons.camera_rounded,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FarmLinkButton(
                    label: 'Gallery',
                    variant: FarmLinkButtonVariant.outline,
                    onPressed: _isAnalyzing ? null : _pickImage,
                    icon: Icons.photo_library_rounded,
                  ),
                ),
              ],
            ),
            if (_isAnalyzing) ...[
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                ),
                child: const Column(
                  children: [
                    CircularProgressIndicator(strokeWidth: 3),
                    SizedBox(height: 16),
                    Text(
                      'AI is analyzing your crop...',
                      style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 40),
            const Text(
              'Diagnostic Tips',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            _buildTipItem(Icons.light_mode_rounded, 'Ensure good natural lighting'),
            _buildTipItem(Icons.center_focus_strong_rounded, 'Keep the affected part in center focus'),
            _buildTipItem(Icons.photo_filter_rounded, 'Avoid using filters or digital zoom'),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.tertiarySoft,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.tertiary, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
