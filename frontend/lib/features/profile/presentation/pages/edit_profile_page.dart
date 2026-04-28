import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmcom/core/theme/app_colors.dart';
import 'package:farmcom/core/presentation/widgets/farmcom_button.dart';
import 'package:farmcom/core/presentation/widgets/farmcom_text_field.dart';
import 'package:farmcom/features/auth/presentation/providers/auth_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;
  late TextEditingController _regionController;
  late TextEditingController _customInterestController;
  final List<String> _availableInterests = [
    'Coffee', 'Maize', 'Poultry', 'Cocoa', 'Vanilla', 'Dairy', 'Livestock', 
    'Rice', 'Beans', 'Bananas', 'Fish Farming', 'Bee Keeping'
  ];
  late List<String> _userInterests;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _nameController = TextEditingController(text: user?.name ?? 'Test Farmer');
    _phoneController = TextEditingController(text: user?.phone ?? '+256 701 234 567');
    _emailController = TextEditingController(text: 'farmer@farmcom.ug');
    _bioController = TextEditingController(text: user?.bio ?? 'Passionate about sustainable coffee farming.');
    _regionController = TextEditingController(text: user?.region ?? 'Central Uganda');
    _customInterestController = TextEditingController();
    _userInterests = List.from(user?.interests ?? ['Coffee', 'Maize', 'Poultry']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _regionController.dispose();
    _customInterestController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    // Logic to save profile via provider would go here
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_userInterests.contains(interest)) {
        _userInterests.remove(interest);
      } else {
        _userInterests.add(interest);
      }
    });
  }

  void _addCustomInterest() {
    if (_customInterestController.text.isNotEmpty) {
      setState(() {
        _userInterests.add(_customInterestController.text);
        _customInterestController.clear();
      });
    }
  }

  void _removeInterest(String interest) {
    setState(() {
      _userInterests.remove(interest);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.w900)),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text('SAVE', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primarySoft,
                    ),
                    child: const Icon(Icons.person_rounded, size: 50, color: AppColors.primary),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            FarmComTextField(labelText: 'Full Name', controller: _nameController, prefixIcon: const Icon(Icons.person_outline_rounded)),
            const SizedBox(height: 20),
            FarmComTextField(labelText: 'Phone Number', controller: _phoneController, prefixIcon: const Icon(Icons.phone_iphone_rounded), keyboardType: TextInputType.phone),
            const SizedBox(height: 20),
            FarmComTextField(labelText: 'Email Address', controller: _emailController, prefixIcon: const Icon(Icons.email_outlined), keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 20),
            FarmComTextField(labelText: 'Bio', controller: _bioController, prefixIcon: const Icon(Icons.info_outline_rounded), maxLength: 150),
            const SizedBox(height: 20),
            FarmComTextField(labelText: 'Region', controller: _regionController, prefixIcon: const Icon(Icons.location_on_outlined)),
            const SizedBox(height: 32),
            Text('Farming Interests', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: isDark ? Colors.white : AppColors.grey900)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableInterests.map((interest) {
                final isSelected = _userInterests.contains(interest);
                return FilterChip(
                  label: Text(interest),
                  selected: isSelected,
                  onSelected: (_) => _toggleInterest(interest),
                  selectedColor: AppColors.primarySoft,
                  checkmarkColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : (isDark ? Colors.white70 : AppColors.grey700),
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text('Your Interests', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: isDark ? Colors.white : AppColors.grey900)),
            const SizedBox(height: 12),
            if (_userInterests.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _userInterests.map((interest) {
                  return Chip(
                    label: Text(
                      interest,
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: isDark ? Colors.white10 : AppColors.primarySoft,
                    onDeleted: () => _removeInterest(interest),
                    deleteIcon: Icon(Icons.close_rounded, size: 18, color: isDark ? Colors.white : AppColors.primary),
                  );
                }).toList(),
              )
            else
              Text('No interests selected yet', style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : AppColors.grey500, fontStyle: FontStyle.italic)),
            const SizedBox(height: 20),
            Text('Add Custom Interest', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: isDark ? Colors.white : AppColors.grey900)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FarmComTextField(
                    labelText: 'Interest name',
                    controller: _customInterestController,
                    prefixIcon: const Icon(Icons.add_rounded),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: _addCustomInterest,
                    icon: const Icon(Icons.add_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            FarmComButton(label: 'Update Profile', onPressed: _saveProfile),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
