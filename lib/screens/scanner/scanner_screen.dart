import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/scan_record.dart';
import '../../services/storage_service.dart';
import '../../services/app_settings.dart';
import '../../theme/app_colors.dart';
import '../result/result_sheet.dart';
import 'widgets/scanner_overlay.dart';
import 'widgets/quick_toolbar.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  final ImagePicker _picker = ImagePicker();
  final StorageService _storage = StorageService();

  bool _torchEnabled = false;
  bool _batchMode = false;
  double _zoomLevel = 0;
  bool _isDetected = false;
  bool _processing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_processing) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    setState(() => _isDetected = true);
    _processing = true;

    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;
    _controller.stop();

    final data = barcode.rawValue!;
    final type = _detectType(data);
    final record = ScanRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      rawData: data,
      label: _truncateLabel(data),
      scannedAt: DateTime.now(),
    );

    await _storage.addRecord(record);

    if (!mounted) return;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ResultSheet(record: record),
    );

    setState(() {
      _isDetected = false;
      _processing = false;
    });
    _controller.start();
  }

  Future<void> _pickFromGallery() async {
    final xFile = await _picker.pickImage(source: ImageSource.gallery);
    if (xFile == null || !mounted) return;

    final image = await _controller.analyzeImage(xFile.path);
    if (!mounted) return;
    if (image != null && image.barcodes.isNotEmpty) {
      final barcode = image.barcodes.first;
      if (barcode.rawValue != null) {
        _onDetect(BarcodeCapture(barcodes: [barcode]));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No QR code found in image')),
      );
    }
  }

  void _toggleTorch() {
    setState(() => _torchEnabled = !_torchEnabled);
    _controller.toggleTorch();
  }

  ScanDataType _detectType(String data) {
    if (data.startsWith('http://') || data.startsWith('https://')) {
      return ScanDataType.url;
    }
    if (data.startsWith('WIFI:')) {
      return ScanDataType.wifi;
    }
    if (RegExp(r'^\d{8,13}$').hasMatch(data)) {
      return ScanDataType.product;
    }
    return ScanDataType.text;
  }

  String _truncateLabel(String data, {int max = 60}) {
    return data.length > max ? '${data.substring(0, max)}...' : data;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppSettings.cameraEnabled,
      builder: (context, cameraOn, _) {
        if (!cameraOn) {
          return Scaffold(
            backgroundColor: AppColors.trueBlack,
            appBar: AppBar(title: const Text('Scanner')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.camera_alt_outlined, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.4)),
                  const SizedBox(height: 16),
                  const Text('Camera is disabled',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  const Text('Enable it in Settings to scan QR codes',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
          );
        }
        return Scaffold(
      backgroundColor: AppColors.trueBlack,
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          ScannerOverlay(isDetected: _isDetected),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/ic_luncher.png', width: 32, height: 32),
                  const SizedBox(width: 10),
                  const Text('FastQR',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          QuickToolbar(
            torchEnabled: _torchEnabled,
            batchMode: _batchMode,
            zoomLevel: _zoomLevel,
            onTorchToggle: _toggleTorch,
            onBatchModeToggle: () => setState(() => _batchMode = !_batchMode),
            onZoomChanged: (v) {
              setState(() => _zoomLevel = v);
              _controller.setZoomScale(v);
            },
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 24,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _pickFromGallery,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.white.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.photo_library_outlined,
                          size: 20, color: AppColors.textPrimary),
                      const SizedBox(width: 8),
                      Text(
                        'Scan from Gallery Asset',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
        },
    );
  }
}
