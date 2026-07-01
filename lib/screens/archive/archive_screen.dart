import 'package:flutter/material.dart';
import '../../models/scan_record.dart';
import '../../services/storage_service.dart';
import '../../theme/app_colors.dart';
import '../result/result_sheet.dart';
import 'widgets/scan_tile.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  final StorageService _storage = StorageService();
  bool _showFavorites = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _storage.load();
      if (mounted) setState(() {});
    });
  }

  List<ScanRecord> get _filteredRecords {
    return _showFavorites ? _storage.favorites : _storage.records;
  }

  void _showResult(ScanRecord record) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ResultSheet(record: record),
    );
  }

  @override
  Widget build(BuildContext context) {
    final records = _filteredRecords;
    final isEmpty = records.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.trueBlack,
      appBar: AppBar(
        title: const Text('Activity Archives'),
        actions: [
          if (!isEmpty)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              color: AppColors.surfaceDark,
              onSelected: (v) {
                if (v == 'csv') _storage.exportToCsv();
                if (v == 'txt') _storage.exportToTxt();
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'csv',
                  child: ListTile(
                    leading: Icon(Icons.table_chart, color: AppColors.textPrimary),
                    title: Text('Export to .CSV', style: TextStyle(color: AppColors.textPrimary)),
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                const PopupMenuItem(
                  value: 'txt',
                  child: ListTile(
                    leading: Icon(Icons.description, color: AppColors.textPrimary),
                    title: Text('Export to .TXT Document', style: TextStyle(color: AppColors.textPrimary)),
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All Recent Scans',
                  selected: !_showFavorites,
                  onTap: () => setState(() => _showFavorites = false),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Saved Favorites Archive',
                  selected: _showFavorites,
                  onTap: () => setState(() => _showFavorites = true),
                ),
              ],
            ),
          ),
          Expanded(
            child: isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _showFavorites ? Icons.star_border : Icons.scanner_outlined,
                          size: 64,
                          color: AppColors.textSecondary.withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _showFavorites
                              ? 'No favorites yet'
                              : 'No scans yet',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _showFavorites
                              ? 'Star your scans to save them here'
                              : 'Scan a QR code to see it appear here',
                          style: TextStyle(
                            color: AppColors.textSecondary.withValues(alpha: 0.6),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return ScanTile(
                        record: record,
                        onTap: () => _showResult(record),
                        onDelete: () => _storage.deleteRecord(record.id).then((_) => setState(() {})),
                        onToggleFavorite: () => _storage.toggleFavorite(record.id).then((_) => setState(() {})),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.neonEmerald.withValues(alpha: 0.2)
              : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.neonEmerald.withValues(alpha: 0.5)
                : AppColors.slateGray.withValues(alpha: 0.3),
          ),
        ),
        child: Text(label,
          style: TextStyle(
            color: selected ? AppColors.neonEmerald : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
