import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../theme/app_colors.dart';

class UrlResultView extends StatelessWidget {
  final String url;

  const UrlResultView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final uri = Uri.tryParse(url);
    final domain = uri?.host ?? 'Unknown';
    final isHttps = url.startsWith('https://');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isHttps ? Icons.lock : Icons.public,
              color: isHttps ? AppColors.neonEmerald : AppColors.warningAmber,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(domain, style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  )),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isHttps
                              ? AppColors.neonEmerald.withValues(alpha: 0.15)
                              : AppColors.warningAmber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isHttps ? 'Verified' : 'Unverified',
                          style: TextStyle(
                            color: isHttps ? AppColors.neonEmerald : AppColors.warningAmber,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(url,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton.icon(
            onPressed: () async {
              if (uri != null && await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open Web Link & Claim Discount'),
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
}
