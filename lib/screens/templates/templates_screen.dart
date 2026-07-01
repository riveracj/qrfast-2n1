import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class TemplatesScreen extends StatelessWidget {
  const TemplatesScreen({super.key});

  static final _templates = [
    _TemplateData('Minimal', Icons.dashboard, AppColors.neonEmerald),
    _TemplateData('Rounded', Icons.rounded_corner, AppColors.electricBlue),
    _TemplateData('Dotted', Icons.circle_outlined, const Color(0xFFA855F7)),
    _TemplateData('Corporate', Icons.business, const Color(0xFFF59E0B)),
    _TemplateData('Gradient', Icons.gradient, const Color(0xFFEC4899)),
    _TemplateData('Neon', Icons.bolt, const Color(0xFF06B6D4)),
    _TemplateData('Vintage', Icons.palette, const Color(0xFFD97706)),
    _TemplateData('Dark', Icons.dark_mode, AppColors.textPrimary),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.trueBlack,
      appBar: AppBar(
        title: const Text('Templates Gallery'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _templates.length,
        itemBuilder: (context, index) {
          final t = _templates[index];
          return GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${t.name} template selected'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: t.color.withValues(alpha: 0.3)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: t.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(t.icon, color: t.color, size: 32),
                  ),
                  const SizedBox(height: 12),
                  Text(t.name,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('QR Template',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TemplateData {
  final String name;
  final IconData icon;
  final Color color;
  const _TemplateData(this.name, this.icon, this.color);
}
