import 'package:flutter/material.dart';
import '../../services/app_settings.dart';
import '../../theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.trueBlack,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionHeader('Camera'),
          const SizedBox(height: 8),
          ValueListenableBuilder<bool>(
            valueListenable: AppSettings.cameraEnabled,
            builder: (context, enabled, _) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      enabled ? Icons.camera_alt : Icons.camera_alt_outlined,
                      color: enabled ? AppColors.neonEmerald : AppColors.textSecondary,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Use Camera on Scan',
                            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            enabled ? 'Camera is active on the Scan tab' : 'Templates shown instead of camera',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: enabled,
                      onChanged: (v) => AppSettings.cameraEnabled.value = v,
                      activeColor: AppColors.neonEmerald,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          _sectionHeader('About'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('FastQR',
                  style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text('Version 1.0.0',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                SizedBox(height: 2),
                Text('QR Code Scanner & Generator',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(title,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
