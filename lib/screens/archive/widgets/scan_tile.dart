import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/scan_record.dart';
import '../../../theme/app_colors.dart';

class ScanTile extends StatelessWidget {
  final ScanRecord record;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onToggleFavorite;

  const ScanTile({
    super.key,
    required this.record,
    required this.onTap,
    required this.onDelete,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(record.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.errorRed.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.errorRed),
      ),
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _typeColor().withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_typeIcon(), size: 20, color: _typeColor()),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(record.label,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('MMM dd, yyyy  HH:mm').format(record.scannedAt.toLocal()),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onToggleFavorite,
                child: Icon(
                  record.isFavorite ? Icons.star : Icons.star_border,
                  color: record.isFavorite ? AppColors.warningAmber : AppColors.textSecondary,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _typeIcon() {
    switch (record.type) {
      case ScanDataType.url: return Icons.link;
      case ScanDataType.wifi: return Icons.wifi;
      case ScanDataType.product: return Icons.shopping_cart;
      case ScanDataType.text: return Icons.text_fields;
      case ScanDataType.unknown: return Icons.help_outline;
    }
  }

  Color _typeColor() {
    switch (record.type) {
      case ScanDataType.url: return AppColors.electricBlue;
      case ScanDataType.wifi: return AppColors.electricBlue;
      case ScanDataType.product: return AppColors.neonEmerald;
      case ScanDataType.text: return AppColors.textSecondary;
      case ScanDataType.unknown: return AppColors.textSecondary;
    }
  }
}
