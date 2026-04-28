part of '../pages/dashboard_page.dart';

class AIQuickScanButton extends ConsumerWidget {
  const AIQuickScanButton({super.key}) : super();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FarmComCard(
      padding: EdgeInsets.zero,
      color: AppColors.primary,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CameraDiagnosticPage(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.camera_rounded, color: AppColors.white, size: 32),
            ),
            const SizedBox(width: 20),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI QUICK-SCAN',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Instantly identify crop diseases',
                    style: TextStyle(
                      color: AppColors.primarySoft,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.white, size: 16),
          ],
        ),
      ),
    );
  }
}
