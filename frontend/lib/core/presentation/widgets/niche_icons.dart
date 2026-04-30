import 'package:flutter/material.dart';

/// Icon mapping for agricultural niches/crops
/// Provides semantic icons for all supported crop communities
class NicheIconProvider {
  /// All supported crop niches
  static const List<String> supportedNiches = [
    'coffee',
    'maize',
    'poultry',
    'matooke',
    'vegetables',
    'livestock',
    'rice',
    'millet',
    'beans',
    'groundnuts',
  ];

  /// Get icon data for a niche
  static IconData getIconForNiche(String niche) {
    final normalized = niche.toLowerCase().trim();
    
    switch (normalized) {
      case 'coffee':
      case 'coffee growers':
        return Icons.local_cafe;
      
      case 'maize':
      case 'corn':
        return Icons.grain;
      
      case 'poultry':
      case 'chicken':
      case 'birds':
        return Icons.pets;
      
      case 'matooke':
      case 'plantain':
      case 'bananas':
        return Icons.fastfood;
      
      case 'vegetables':
      case 'greens':
      case 'cabbage':
        return Icons.energy_savings_leaf;
      
      case 'livestock':
      case 'cattle':
      case 'goats':
      case 'sheep':
        return Icons.hail;
      
      case 'rice':
        return Icons.water_drop;
      
      case 'millet':
      case 'sorghum':
        return Icons.grain;
      
      case 'beans':
      case 'pulses':
        return Icons.circle;
      
      case 'groundnuts':
      case 'peanuts':
        return Icons.circle;
      
      default:
        return Icons.agriculture;
    }
  }

  /// Get emoji for a niche
  static String getEmojiForNiche(String niche) {
    final normalized = niche.toLowerCase().trim();
    
    switch (normalized) {
      case 'coffee':
      case 'coffee growers':
        return '☕';
      case 'maize':
      case 'corn':
        return '🌽';
      case 'poultry':
      case 'chicken':
      case 'birds':
        return '🐔';
      case 'matooke':
      case 'plantain':
      case 'bananas':
        return '🍌';
      case 'vegetables':
      case 'greens':
      case 'cabbage':
        return '🥬';
      case 'livestock':
      case 'cattle':
      case 'goats':
      case 'sheep':
        return '🐄';
      case 'rice':
        return '🍚';
      case 'millet':
      case 'sorghum':
        return '🌾';
      case 'beans':
      case 'pulses':
        return '🫘';
      case 'groundnuts':
      case 'peanuts':
        return '🥜';
      default:
        return '🌱';
    }
  }

  /// Get color for a niche
  static Color getColorForNiche(String niche) {
    final normalized = niche.toLowerCase().trim();
    
    switch (normalized) {
      case 'coffee':
      case 'coffee growers':
        return const Color(0xFF6F4E37); // Brown
      case 'maize':
      case 'corn':
        return const Color(0xFFFFD700); // Gold
      case 'poultry':
      case 'chicken':
      case 'birds':
        return const Color(0xFFFF8C00); // Orange
      case 'matooke':
      case 'plantain':
      case 'bananas':
        return const Color(0xFFFFC700); // Yellow
      case 'vegetables':
      case 'greens':
      case 'cabbage':
        return const Color(0xFF2E7D32); // Green
      case 'livestock':
      case 'cattle':
      case 'goats':
      case 'sheep':
        return const Color(0xFF8B4513); // Saddle Brown
      case 'rice':
        return const Color(0xFFFAF0E6); // Floral White
      case 'millet':
      case 'sorghum':
        return const Color(0xFFD2B48C); // Tan
      case 'beans':
      case 'pulses':
        return const Color(0xFF8B0000); // Dark Red
      case 'groundnuts':
      case 'peanuts':
        return const Color(0xFFA0522D); // Sienna
      default:
        return const Color(0xFF2E7D32); // Default green
    }
  }

  /// Get description for a niche
  static String getDescriptionForNiche(String niche) {
    final normalized = niche.toLowerCase().trim();
    
    switch (normalized) {
      case 'coffee':
      case 'coffee growers':
        return 'Coffee growing community';
      case 'maize':
      case 'corn':
        return 'Maize & corn farmers';
      case 'poultry':
      case 'chicken':
      case 'birds':
        return 'Poultry farming community';
      case 'matooke':
      case 'plantain':
      case 'bananas':
        return 'Matooke & plantain farmers';
      case 'vegetables':
      case 'greens':
      case 'cabbage':
        return 'Vegetable growers';
      case 'livestock':
      case 'cattle':
      case 'goats':
      case 'sheep':
        return 'Livestock farmers';
      case 'rice':
        return 'Rice farming community';
      case 'millet':
      case 'sorghum':
        return 'Millet & sorghum farmers';
      case 'beans':
      case 'pulses':
        return 'Beans & pulse crops';
      case 'groundnuts':
      case 'peanuts':
        return 'Groundnut farmers';
      default:
        return 'Agricultural community';
    }
  }
}

/// Niche icon widget with label
class NicheIcon extends StatelessWidget {
  final String niche;
  final double size;
  final bool showLabel;
  final bool useEmoji;

  const NicheIcon({
    Key? key,
    required this.niche,
    this.size = 40,
    this.showLabel = false,
    this.useEmoji = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = NicheIconProvider.getColorForNiche(niche);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (useEmoji)
          Text(
            NicheIconProvider.getEmojiForNiche(niche),
            style: TextStyle(fontSize: size),
          )
        else
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                NicheIconProvider.getIconForNiche(niche),
                color: color,
                size: size * 0.6,
              ),
            ),
          ),
        if (showLabel) ...[
          const SizedBox(height: 8),
          Text(
            NicheIconProvider.getDescriptionForNiche(niche),
            style: Theme.of(context).textTheme.labelSmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

/// Niche badge with emoji
class NicheBadge extends StatelessWidget {
  final String niche;
  final bool compact;

  const NicheBadge({
    Key? key,
    required this.niche,
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emoji = NicheIconProvider.getEmojiForNiche(niche);
    final color = NicheIconProvider.getColorForNiche(niche);

    if (compact) {
      return Text(emoji, style: const TextStyle(fontSize: 18));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color, width: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji),
          const SizedBox(width: 6),
          Text(
            NicheIconProvider.getDescriptionForNiche(niche),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}

/// Grid of niche icons for selection
class NicheIconGrid extends StatelessWidget {
  final List<String> niches;
  final String? selectedNiche;
  final ValueChanged<String> onNicheSelected;
  final bool useEmoji;

  const NicheIconGrid({
    Key? key,
    required this.niches,
    this.selectedNiche,
    required this.onNicheSelected,
    this.useEmoji = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: niches.length,
      itemBuilder: (context, index) {
        final niche = niches[index];
        final isSelected = selectedNiche == niche;
        final color = NicheIconProvider.getColorForNiche(niche);

        return GestureDetector(
          onTap: () => onNicheSelected(niche),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? color : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
              color: isSelected
                  ? color.withValues(alpha: 0.1)
                  : Colors.transparent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (useEmoji)
                  Text(
                    NicheIconProvider.getEmojiForNiche(niche),
                    style: const TextStyle(fontSize: 40),
                  )
                else
                  Icon(
                    NicheIconProvider.getIconForNiche(niche),
                    color: color,
                    size: 32,
                  ),
                const SizedBox(height: 8),
                Text(
                  niche,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
