import 'package:flutter/material.dart';
import 'package:farmlink_ug/core/theme/app_colors.dart';
import 'package:farmlink_ug/core/presentation/widgets/ui_refinement_kit.dart';
import 'package:farmlink_ug/core/presentation/widgets/offline_indicator.dart';

class DiagnosticsPage extends StatelessWidget {
  const DiagnosticsPage({super.key}) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIRefinementKit.buildGradientAppBar(
        context: context,
        title: 'AI Camera Diagnostics',
        showLeading: true,
        onLeadingPressed: () => Navigator.of(context).pop(),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
            },
            color: AppColors.primary,
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: AppColors.primary,
                              size: 50,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'AI-Powered Plant Diagnostics',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Point your camera at a plant to get instant disease diagnosis, treatment recommendations, and expert guidance.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          UIRefinementKit.buildInfoBox(
                            context: context,
                            title: 'How It Works',
                            message: 'Our AI analyzes leaf patterns, color anomalies, and plant symptoms. Results with 85% confidence or higher are displayed with treatment options.',
                            icon: Icons.lightbulb_outline_rounded,
                            iconColor: AppColors.warning,
                            backgroundColor: AppColors.warningLight.withValues(alpha: 0.1),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: UIRefinementKit.buildGradientButton(
                              label: 'Start Diagnosis',
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: OfflineIndicator(),
          ),
        ],
      ),
    );
  }
}
