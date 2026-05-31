import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../../theme/app_colors.dart';

class StyleAccordion extends StatefulWidget {
  final Color qrColor;
  final ValueChanged<Color> onColorChanged;
  final VoidCallback onLogoSelected;

  const StyleAccordion({
    super.key,
    required this.qrColor,
    required this.onColorChanged,
    required this.onLogoSelected,
  });

  @override
  State<StyleAccordion> createState() => _StyleAccordionState();
}

class _StyleAccordionState extends State<StyleAccordion> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.palette_outlined, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 10),
                const Text('Style & Customization',
                  style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: widget.qrColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.expand_more, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Change App Matrix Color Theme',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  ColorPicker(
                    pickerColor: widget.qrColor,
                    onColorChanged: widget.onColorChanged,
                    enableAlpha: false,
                    labelTypes: const [],
                    pickerAreaHeightPercent: 0.7,
                    hexInputBar: true,
                    hexInputController: TextEditingController(text: '#${widget.qrColor.toARGB32().toRadixString(16).substring(2)}'),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.slateGray),
                  const SizedBox(height: 12),
                  const Text('Insert Central Identity Logo',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: widget.onLogoSelected,
                    icon: const Icon(Icons.image_outlined),
                    label: const Text('Upload Image'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.slateGray),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}
