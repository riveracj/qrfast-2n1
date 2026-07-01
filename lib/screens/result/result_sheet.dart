import 'package:flutter/material.dart';
import '../../models/scan_record.dart';
import '../../theme/app_colors.dart';
import 'widgets/url_result_view.dart';
import 'widgets/wifi_result_view.dart';
import 'widgets/product_result_view.dart';

class ResultSheet extends StatelessWidget {
  final ScanRecord record;

  const ResultSheet({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.3,
      maxChildSize: 0.7,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          decoration: const BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.slateGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _TypeBadge(type: record.type),
              const SizedBox(height: 16),
              _buildContent(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    switch (record.type) {
      case ScanDataType.url:
        return UrlResultView(url: record.rawData);
      case ScanDataType.wifi:
        return WifiResultView(rawData: record.rawData);
      case ScanDataType.product:
        return ProductResultView(barcode: record.rawData);
      case ScanDataType.text:
      case ScanDataType.unknown:
        return _DefaultResultView(record: record);
    }
  }
}

class _TypeBadge extends StatelessWidget {
  final ScanDataType type;

  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final config = _config();
    return Row(
      children: [
        Icon(config.icon, size: 16, color: config.color),
        const SizedBox(width: 6),
        Text(config.label,
          style: TextStyle(
            color: config.color,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  _BadgeConfig _config() {
    switch (type) {
      case ScanDataType.url:
        return _BadgeConfig(Icons.link, AppColors.electricBlue, 'URL');
      case ScanDataType.wifi:
        return _BadgeConfig(Icons.wifi, AppColors.electricBlue, 'Wi-Fi Network');
      case ScanDataType.product:
        return _BadgeConfig(Icons.shopping_cart, AppColors.neonEmerald, 'Product Barcode');
      case ScanDataType.text:
        return _BadgeConfig(Icons.text_fields, AppColors.textSecondary, 'Text');
      case ScanDataType.unknown:
        return _BadgeConfig(Icons.help_outline, AppColors.textSecondary, 'Unknown');
    }
  }
}

class _BadgeConfig {
  final IconData icon;
  final Color color;
  final String label;
  _BadgeConfig(this.icon, this.color, this.label);
}

class _DefaultResultView extends StatelessWidget {
  final ScanRecord record;

  const _DefaultResultView({required this.record});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Scanned Content',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SelectableText(
            record.rawData,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: copy to clipboard
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copy to Clipboard'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.slateGray),
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
