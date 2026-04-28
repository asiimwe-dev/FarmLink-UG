part of '../pages/dashboard_page.dart';

class MarketPulseList extends ConsumerWidget {
  const MarketPulseList({super.key}) : super();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prices = [
      {
        'crop': 'Coffee (Robusta)',
        'buyPrice': '8,200',
        'sellPrice': '8,500',
        'unit': 'kg',
        'trend': 'up'
      },
      {
        'crop': 'Maize',
        'buyPrice': '1,100',
        'sellPrice': '1,200',
        'unit': 'kg',
        'trend': 'stable'
      },
      {
        'crop': 'Vanilla',
        'buyPrice': '48,000',
        'sellPrice': '50,000',
        'unit': 'kg',
        'trend': 'down'
      },
    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = prices[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _MarketPriceLine(item: item),
            );
          },
          childCount: prices.length,
        ),
      ),
    );
  }
}

class _MarketPriceLine extends StatelessWidget {
  final Map<String, String> item;

  const _MarketPriceLine({required this.item});

  @override
  Widget build(BuildContext context) {
    final trend = item['trend']!;
    
    return FarmComCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['crop']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 12, color: AppColors.grey500),
                    const SizedBox(width: 4),
                    const Text(
                      'Updated 2h ago',
                      style: TextStyle(
                        color: AppColors.grey500,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildPriceColumn('BUY', item['buyPrice']!, AppColors.tertiary),
          const SizedBox(width: 12),
          _TrendIndicator(trend: trend),
          const SizedBox(width: 12),
          _buildPriceColumn('SELL', item['sellPrice']!, AppColors.success),
        ],
      ),
    );
  }

  Widget _buildPriceColumn(String label, String price, Color color) {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: AppColors.grey500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Shs $price',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendIndicator extends StatelessWidget {
  final String trend;
  const _TrendIndicator({required this.trend});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    Color bg;

    switch (trend) {
      case 'up':
        icon = Icons.trending_up_rounded;
        color = AppColors.success;
        bg = AppColors.success.withValues(alpha: 0.1);
        break;
      case 'down':
        icon = Icons.trending_down_rounded;
        color = AppColors.error;
        bg = AppColors.error.withValues(alpha: 0.1);
        break;
      default:
        icon = Icons.trending_flat_rounded;
        color = AppColors.warning;
        bg = AppColors.warning.withValues(alpha: 0.1);
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}
