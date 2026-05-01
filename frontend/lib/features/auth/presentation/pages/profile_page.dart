import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmlink_ug/core/constants/app_strings.dart';
import 'package:farmlink_ug/core/theme/app_colors.dart';
import 'package:farmlink_ug/core/theme/spacing_constants.dart';
import 'package:farmlink_ug/core/presentation/widgets/ui_refinement_kit.dart';
import '../providers/auth_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key}) : super();

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late TextEditingController nameController;
  late TextEditingController bioController;
  String? selectedRegion;
  Set<String> selectedInterests = {};

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    bioController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(AppStrings.loading),
        ),
      );
    }

    // Initialize fields on first build
    if (nameController.text.isEmpty && user.name != null) {
      nameController.text = user.name ?? '';
      bioController.text = user.bio ?? '';
      selectedRegion = user.region;
      selectedInterests = user.interests.toSet();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.profile),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phone (read-only)
              Text(
                'Phone',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  user.phone,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              SizedBox(height: 24),

              // Name
              Text(
                'Name',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Your name',
                  enabled: !authState.isLoading,
                ),
              ),
              SizedBox(height: 24),

              // Bio
              Text(
                'Bio',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8),
              TextField(
                controller: bioController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Tell us about yourself',
                  enabled: !authState.isLoading,
                ),
              ),
              SizedBox(height: 24),

              // Region
              Text(
                'Region',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 8),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedRegion,
                items: [
                  'Mt. Elgon',
                  'Central Uganda',
                  'Eastern Uganda',
                  'Northern Uganda',
                  'Western Uganda',
                ]
                    .map((region) => DropdownMenuItem(
                          value: region,
                          child: Text(region),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => selectedRegion = value),
              ),
              SizedBox(height: 24),

              // Interests (crops)
              Text(
                'Crops (Select your interests)',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  'Coffee',
                  'Maize',
                  'Beans',
                  'Banana',
                  'Tea',
                  'Cassava',
                  'Potatoes',
                  'Rice',
                ]
                    .map((crop) => FilterChip(
                          label: Text(crop),
                          selected: selectedInterests.contains(crop),
                          onSelected: (selected) => setState(() {
                            if (selected) {
                              selectedInterests.add(crop);
                            } else {
                              selectedInterests.remove(crop);
                            }
                          }),
                        ))
                    .toList(),
              ),
              SizedBox(height: 32),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authState.isLoading
                      ? null
                      : () {
                          ref.read(authProvider.notifier).updateProfile(
                            name: nameController.text,
                            bio: bioController.text,
                            region: selectedRegion,
                            interests: selectedInterests.toList(),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Profile updated')),
                          );
                        },
                  child: authState.isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation(AppColors.white),
                          ),
                        )
                      : Text('Save Profile'),
                ),
              ),
              SizedBox(height: 12),

              // Logout button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: authState.isLoading
                      ? null
                      : () {
                          ref.read(authProvider.notifier).logout();
                        },
                  child: Text(AppStrings.logout),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
