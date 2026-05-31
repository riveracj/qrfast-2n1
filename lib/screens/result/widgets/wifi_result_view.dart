import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class WifiResultView extends StatelessWidget {
  final String rawData;

  const WifiResultView({super.key, required this.rawData});

  @override
  Widget build(BuildContext context) {
    final ssid = _extractValue('S:');
    final encryption = _extractValue('T:');
    final password = _extractValue('P:');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(label: 'Network SSID', value: ssid, icon: Icons.wifi),
        const SizedBox(height: 12),
        _InfoRow(label: 'Encryption Protocol', value: encryption, icon: Icons.security),
        const SizedBox(height: 12),
        if (password.isNotEmpty)
          _InfoRow(label: 'Password', value: password, icon: Icons.key, obscured: true),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opening Wi-Fi settings...')),
              );
            },
            icon: const Icon(Icons.wifi_find),
            label: const Text('Connect to WiFi Instantly'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.electricBlue,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _extractValue(String prefix) {
    final parts = rawData.split(';');
    for (final part in parts) {
      final trimmed = part.trim();
      if (trimmed.startsWith(prefix)) {
        return trimmed.substring(2);
      }
    }
    return 'Unknown';
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool obscured;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.obscured = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.neonEmerald),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                obscured ? '••••••••' : value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
