import 'package:flutter/material.dart';
import 'package:farmcom/core/theme/app_typography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:farmcom/core/theme/app_colors.dart';
import 'package:farmcom/core/presentation/widgets/farmcom_card.dart';
import 'package:farmcom/core/presentation/widgets/farmcom_button.dart';

class CameraDiagnosticPage extends ConsumerStatefulWidget {
  const CameraDiagnosticPage({super.key});

  @override
  ConsumerState<CameraDiagnosticPage> createState() => _CameraDiagnosticPageState();
}

class _CameraDiagnosticPageState extends ConsumerState<CameraDiagnosticPage> {
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _analyzeImage() async {
    setState(() {
      _isAnalyzing = true;
    });

    // Simulate AI analysis
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isAnalyzing = false;
      });
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
                  style: AppTypography.titleLarge.copyWith( fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Identified Issue:',
              style: TextStyle(// Use AppTypography for font consistency (was AppTypography.titleSmall, w700), color: AppColors.grey500),
            ),
            const SizedBox(height: 4),
            const Text(
              'Coffee Leaf Rust (Puccinia triticina)',
              style: AppTypography.titleLarge.copyWith( fontWeight: FontWeight.w900, color: AppColors.primary),
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
                style: AppTypography.labelMedium.copyWith( fontWeight: FontWeight.w800, color: AppColors.primaryDark),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Recommended Treatment:',
              style: AppTypography.titleMedium.copyWith( fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            _buildRecommendationItem('Apply approved copper-based fungicide'),
            _buildRecommendationItem('Prune affected leaves and destroy them'),
            _buildRecommendationItem('Ensure proper plant spacing for air flow'),
            _buildRecommendationItem('Monitor soil moisture levels'),
            const SizedBox(height: 40),
            FarmComButton(
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
            FarmComButton(
              label: 'Talk to Expert',
              variant: FarmComButtonVariant.outline,
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
              style: const AppTypography.titleSmall.copyWith( fontWeight: FontWeight.w500),
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 1,
            backgroundColor: isDark ? AppColors.darkSurfaceBright : Colors.white,
            automaticallyImplyLeading: false,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final top = constraints.biggest.height;
                final isCollapsed = top < (MediaQuery.of(context).padding.top + 70);
                final contentColor = isDark 
                    ? Colors.white 
                    : (isCollapsed ? AppColors.grey900 : Colors.white);

                return FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 14),
                  title: Text(
                    'Crop Diagnostics',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      AppTypography.titleMedium,
                      color: contentColor,
                    ),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primaryDark, AppColors.primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_selectedImage != null)
                    FarmComCard(
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
                    FarmComCard(
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
                              style: AppTypography.titleMedium.copyWith( fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'AI will identify diseases and remedies',
                              textAlign: TextAlign.center,
                              style: AppTypography.bodySmall.copyWith( color: AppColors.grey500, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: FarmComButton(
                          label: 'Take Photo',
                          onPressed: _isAnalyzing ? null : _captureImage,
                          icon: Icons.camera_rounded,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FarmComButton(
                          label: 'Gallery',
                          variant: FarmComButtonVariant.outline,
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
                    style: AppTypography.titleLarge.copyWith( fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 16),
                  _buildTipItem(Icons.light_mode_rounded, 'Ensure good natural lighting'),
                  _buildTipItem(Icons.center_focus_strong_rounded, 'Keep the affected part in center focus'),
                  _buildTipItem(Icons.photo_filter_rounded, 'Avoid using filters or digital zoom'),
                  const SizedBox(height: 40),
                  const Text(
                    'Recent Diagnoses',
                    style: AppTypography.titleLarge.copyWith( fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 16),
                  _buildRecentDiagnosis(
                    'Coffee Leaf Rust',
                    'April 28, 2026',
                    '87%',
                    AppColors.primary,
                    'Fungal infection - apply fungicide',
                  ),
                  _buildRecentDiagnosis(
                    'Bacterial Wilt',
                    'April 25, 2026',
                    '92%',
                    AppColors.secondary,
                    'Remove affected plants immediately',
                  ),
                  _buildRecentDiagnosis(
                    'Nutrient Deficiency',
                    'April 20, 2026',
                    '78%',
                    AppColors.tertiary,
                    'Soil amendment needed',
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Quick Recommendations',
                    style: AppTypography.titleLarge.copyWith( fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 16),
                  _buildQuickRecommendation(
                    'Preventive Care',
                    'Regular scouting and monitoring reduce disease incidence',
                    Icons.shield_rounded,
                    AppColors.primary,
                  ),
                  _buildQuickRecommendation(
                    'Weather Alert',
                    'High humidity expected - fungal risk increases',
                    Icons.cloud_rounded,
                    AppColors.warning,
                  ),
                  _buildQuickRecommendation(
                    'Best Practices',
                    'Maintain 30% plant spacing for better airflow',
                    Icons.agriculture_rounded,
                    AppColors.tertiary,
                  ),
                  const SizedBox(height: 40),
                  FarmComCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.tertiarySoft,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.support_agent_rounded, color: AppColors.tertiary, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Need Expert Help?',
                                    style: AppTypography.titleSmall.copyWith( fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Chat with agricultural experts',
                                    style: AppTypography.labelMedium.copyWith( color: AppColors.grey500, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_rounded, color: AppColors.tertiary),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
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
              style: const AppTypography.titleSmall.copyWith( fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentDiagnosis(
    String title,
    String date,
    String confidence,
    Color color,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: FarmComCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const AppTypography.titleSmall.copyWith( fontWeight: FontWeight.w800),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Confidence: $confidence',
                    style: AppTypography.labelSmall.copyWith( fontWeight: FontWeight.w700, color: color),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              date,
              style: const AppTypography.labelMedium.copyWith( color: AppColors.grey500, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const AppTypography.bodySmall.copyWith( fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickRecommendation(String title, String description, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const AppTypography.titleSmall.copyWith( fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const AppTypography.labelMedium.copyWith( color: AppColors.grey500, fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
