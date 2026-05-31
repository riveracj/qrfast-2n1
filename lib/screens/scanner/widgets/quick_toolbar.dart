import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class QuickToolbar extends StatelessWidget {
  final bool torchEnabled;
  final bool batchMode;
  final double zoomLevel;
  final VoidCallback onTorchToggle;
  final VoidCallback onBatchModeToggle;
  final ValueChanged<double> onZoomChanged;

  const QuickToolbar({
    super.key,
    required this.torchEnabled,
    required this.batchMode,
    required this.zoomLevel,
    required this.onTorchToggle,
    required this.onBatchModeToggle,
    required this.onZoomChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16,
      right: 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              children: [
                _ToolbarButton(
                  icon: torchEnabled ? Icons.flash_on : Icons.flash_off,
                  active: torchEnabled,
                  onTap: onTorchToggle,
                ),
                const SizedBox(width: 4),
                _ToolbarButton(
                  icon: Icons.layers,
                  active: batchMode,
                  onTap: onBatchModeToggle,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.zoom_in, size: 14, color: AppColors.textSecondary),
                          Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 2,
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                                activeTrackColor: AppColors.neonEmerald,
                                inactiveTrackColor: AppColors.white.withValues(alpha: 0.2),
                                thumbColor: AppColors.white,
                              ),
                              child: Slider(
                                value: zoomLevel,
                                min: 0.0,
                                max: 1.0,
                                onChanged: onZoomChanged,
                              ),
                            ),
                          ),
                          const Icon(Icons.zoom_out, size: 14, color: AppColors.textSecondary),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _ToolbarButton({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: active
              ? AppColors.neonEmerald.withValues(alpha: 0.25)
              : AppColors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: active
              ? Border.all(color: AppColors.neonEmerald.withValues(alpha: 0.5))
              : null,
        ),
        child: Icon(
          icon,
          size: 20,
          color: active ? AppColors.neonEmerald : AppColors.textSecondary,
        ),
      ),
    );
  }
}
