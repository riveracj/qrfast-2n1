import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

enum QrFormat { text, url, vcard, wifi, sms, clipboard }

class FormatSelector extends StatelessWidget {
  final QrFormat selected;
  final ValueChanged<QrFormat> onChanged;

  const FormatSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: QrFormat.values.map((format) {
          final isSelected = format == selected;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(_label(format)),
              selected: isSelected,
              onSelected: (_) => onChanged(format),
              selectedColor: AppColors.neonEmerald.withValues(alpha: 0.25),
              backgroundColor: AppColors.surfaceCard,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.neonEmerald : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 13,
              ),
              side: BorderSide(
                color: isSelected
                    ? AppColors.neonEmerald.withValues(alpha: 0.5)
                    : AppColors.slateGray.withValues(alpha: 0.3),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _label(QrFormat format) {
    switch (format) {
      case QrFormat.text:
        return 'Text';
      case QrFormat.url:
        return 'Website Link';
      case QrFormat.vcard:
        return 'vCard';
      case QrFormat.wifi:
        return 'Wi-Fi';
      case QrFormat.sms:
        return 'SMS';
      case QrFormat.clipboard:
        return 'Clipboard';
    }
  }
}
