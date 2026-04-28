import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmcom/core/constants/app_strings.dart';
import 'package:farmcom/core/theme/app_colors.dart';
import 'package:farmcom/core/presentation/widgets/farmcom_button.dart';
import 'package:farmcom/core/presentation/widgets/farmcom_text_field.dart';
import '../providers/auth_provider.dart';

class OTPPage extends ConsumerStatefulWidget {
  const OTPPage({super.key}) : super();

  @override
  ConsumerState<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends ConsumerState<OTPPage> {
  late PageController _pageController;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  void _sendOTP() {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.invalidPhone)),
      );
      return;
    }

    ref.read(authProvider.notifier).sendOTP(phone);

    // Move to OTP page
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuart,
    );
  }

  void _verifyOTP() {
    final phone = phoneController.text.trim();
    final otp = otpController.text.trim();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.invalidOTP)),
      );
      return;
    }

    ref.read(authProvider.notifier).verifyOTP(phone, otp);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Decorative Elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primarySoft.withValues(alpha: 0.5),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondarySoft.withValues(alpha: 0.3),
              ),
            ),
          ),
          
          SafeArea(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildPhonePage(context, authState),
                _buildOTPPage(context, authState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhonePage(BuildContext context, AuthState authState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.agriculture_rounded,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Welcome to FarmCom',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.grey900,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Empowering farmers through community and technology.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.grey600,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 48),
          FarmComTextField(
            controller: phoneController,
            labelText: AppStrings.enterPhone,
            hintText: AppStrings.phoneHint,
            prefixIcon: const Icon(Icons.phone_iphone_rounded, color: AppColors.primary),
            keyboardType: TextInputType.phone,
            enabled: !authState.isLoading,
          ),
          const SizedBox(height: 32),
          FarmComButton(
            label: AppStrings.sendOTP,
            onPressed: _sendOTP,
            isLoading: authState.isLoading,
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'By continuing, you agree to our Terms and Conditions',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.grey500,
              ),
            ),
          ),
          if (authState.error case final error?) ...[
            _buildErrorWidget(error.message),
          ],
        ],
      ),
    );
  }

  Widget _buildOTPPage(BuildContext context, AuthState authState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          IconButton(
            onPressed: () => _pageController.previousPage(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutQuart,
            ),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.grey100,
              padding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            AppStrings.verifyOTP,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.grey900,
                ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.grey600,
                    height: 1.5,
                  ),
              children: [
                const TextSpan(text: 'We\'ve sent a 6-digit verification code to '),
                TextSpan(
                  text: phoneController.text,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          FarmComTextField(
            controller: otpController,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: 8,
              color: AppColors.primary,
            ),
            keyboardType: TextInputType.number,
            maxLength: 6,
            enabled: !authState.isLoading,
          ),
          const SizedBox(height: 32),
          FarmComButton(
            label: AppStrings.confirm,
            onPressed: _verifyOTP,
            isLoading: authState.isLoading,
          ),
          const SizedBox(height: 24),
          Center(
            child: TextButton(
              onPressed: authState.isLoading ? null : () {
                // Resend logic
              },
              child: const Text(
                'Didn\'t receive the code? Resend',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          if (authState.error case final error?) ...[
            _buildErrorWidget(error.message),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
