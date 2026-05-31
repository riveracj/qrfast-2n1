import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class ProductResultView extends StatelessWidget {
  final String barcode;

  const ProductResultView({super.key, required this.barcode});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text('Barcode: $barcode',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _PriceColumn(label: 'Retail Store Price', price: '—'),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.slateGray.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.compare_arrows, color: AppColors.textSecondary, size: 20),
                  ),
                  _PriceColumn(label: 'Online Price Comparison', price: '—'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.warningAmber.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.warningAmber.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.warningAmber, size: 18),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Online price lookup requires internet connection',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Searching for best deals...')),
              );
            },
            icon: const Icon(Icons.shopping_bag),
            label: const Text('View Cheapest Online Deal'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.neonEmerald,
              foregroundColor: AppColors.trueBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PriceColumn extends StatelessWidget {
  final String label;
  final String price;

  const _PriceColumn({required this.label, required this.price});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(price,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
