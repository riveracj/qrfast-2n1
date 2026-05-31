import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_colors.dart';
import '../../models/scan_record.dart';
import '../../services/storage_service.dart';
import 'widgets/format_selector.dart';
import 'widgets/style_accordion.dart';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  QrFormat _selectedFormat = QrFormat.text;
  final _textController = TextEditingController();
  Color _qrColor = AppColors.neonEmerald;
  Uint8List? _logoBytes;
  final ImagePicker _picker = ImagePicker();
  final StorageService _storage = StorageService();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String get _qrData {
    final text = _textController.text.trim();
    if (text.isEmpty) return '';

    switch (_selectedFormat) {
      case QrFormat.url:
        return text.startsWith('http') ? text : 'https://$text';
      case QrFormat.wifi:
        return 'WIFI:S:$text;T:WPA;;';
      case QrFormat.sms:
        return 'SMSTO:$text:';
      default:
        return text;
    }
  }

  bool get _hasValidData => _qrData.isNotEmpty;

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      _textController.text = data!.text!;
    }
  }

  Future<void> _pickLogo() async {
    final xFile = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 200, maxHeight: 200);
    if (xFile != null) {
      final bytes = await xFile.readAsBytes();
      setState(() => _logoBytes = bytes);
    }
  }

  Future<void> _exportQr() async {
    if (!_hasValidData) return;

    final record = ScanRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: ScanDataType.text,
      rawData: _qrData,
      label: _textController.text,
      scannedAt: DateTime.now(),
    );
    await _storage.addRecord(record);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('QR Code generated & saved to history'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        title: const Text('Generation Studio'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormatSelector(selected: _selectedFormat, onChanged: (v) {
              setState(() => _selectedFormat = v);
              if (v == QrFormat.clipboard) {
                _pasteFromClipboard();
              }
            }),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _textController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: _hintText(),
                      hintStyle: const TextStyle(color: AppColors.textSecondary),
                      border: InputBorder.none,
                      filled: false,
                    ),
                    style: const TextStyle(color: AppColors.trueBlack, fontSize: 15),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  if (_selectedFormat == QrFormat.clipboard)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: _pasteFromClipboard,
                        icon: const Icon(Icons.content_paste, size: 16),
                        label: const Text('Refresh from Clipboard'),
                        style: TextButton.styleFrom(foregroundColor: AppColors.electricBlue),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: _hasValidData
                    ? QrImageView(
                        data: _qrData,
                        version: QrVersions.auto,
                        size: 200,
                        eyeStyle: QrEyeStyle(color: _qrColor),
                        dataModuleStyle: QrDataModuleStyle(color: _qrColor),
                        embeddedImage: _logoBytes != null
                            ? MemoryImage(_logoBytes!)
                            : null,
                        embeddedImageStyle: _logoBytes != null
                            ? const QrEmbeddedImageStyle(size: Size(48, 48))
                            : null,
                      )
                    : Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(Icons.qr_code_2, size: 64, color: AppColors.textSecondary),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            StyleAccordion(
              qrColor: _qrColor,
              onColorChanged: (c) => setState(() => _qrColor = c),
              onLogoSelected: _pickLogo,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                onPressed: _hasValidData ? _exportQr : null,
                icon: const Icon(Icons.file_download),
                label: const Text('Export High-Res Vector (PNG, SVG, or Print Format)'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.neonEmerald,
                  foregroundColor: AppColors.trueBlack,
                  disabledBackgroundColor: AppColors.slateGray.withValues(alpha: 0.3),
                  disabledForegroundColor: AppColors.textSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _hintText() {
    switch (_selectedFormat) {
      case QrFormat.text:
        return 'Enter text content...';
      case QrFormat.url:
        return 'https://example.com';
      case QrFormat.vcard:
        return 'BEGIN:VCARD\nFN:John Doe\nTEL:+1234567890\nEND:VCARD';
      case QrFormat.wifi:
        return 'Network name (SSID)';
      case QrFormat.sms:
        return '+1234567890';
      case QrFormat.clipboard:
        return 'Clipboard content appears here...';
    }
  }
}
