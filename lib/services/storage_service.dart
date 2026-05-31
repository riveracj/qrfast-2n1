import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';
import '../models/scan_record.dart';

class StorageService {
  static final StorageService _instance = StorageService._();
  factory StorageService() => _instance;
  StorageService._();

  List<ScanRecord> _records = [];
  final String _fileName = 'scan_history.json';

  List<ScanRecord> get records => List.unmodifiable(_records);
  List<ScanRecord> get favorites => _records.where((r) => r.isFavorite).toList();

  Future<void> load() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(contents);
        _records = jsonList.map((e) => _fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
  }

  Future<void> addRecord(ScanRecord record) async {
    _records.insert(0, record);
    await _persist();
  }

  Future<void> toggleFavorite(String id) async {
    final index = _records.indexWhere((r) => r.id == id);
    if (index != -1) {
      _records[index] = _records[index].copyWith(isFavorite: !_records[index].isFavorite);
      await _persist();
    }
  }

  Future<void> deleteRecord(String id) async {
    _records.removeWhere((r) => r.id == id);
    await _persist();
  }

  Future<void> exportToCsv() async {
    final rows = [ScanRecord.csvHeaders(), ..._records.map((r) => r.toCsvRow().values.toList())];
    final csv = const ListToCsvConverter().convert(rows);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/qrfast_export_${DateTime.now().millisecondsSinceEpoch}.csv');
    await file.writeAsString(csv);
    await Share.shareXFiles([XFile(file.path)], text: 'Scan History Export');
  }

  Future<void> exportToTxt() async {
    final buffer = StringBuffer();
    buffer.writeln('QRFast Scan History');
    buffer.writeln('=' * 40);
    for (final r in _records) {
      buffer.writeln('${r.scannedAt.toLocal()}: [${r.type.name.toUpperCase()}] ${r.label}');
      buffer.writeln('  Data: ${r.rawData}');
      buffer.writeln('');
    }
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/qrfast_export_${DateTime.now().millisecondsSinceEpoch}.txt');
    await file.writeAsString(buffer.toString());
    await Share.shareXFiles([XFile(file.path)], text: 'Scan History Export');
  }

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<void> _persist() async {
    final file = await _getFile();
    final jsonList = _records.map((r) => _toJson(r)).toList();
    await file.writeAsString(jsonEncode(jsonList));
  }

  Map<String, dynamic> _toJson(ScanRecord r) => {
        'id': r.id,
        'type': r.type.name,
        'rawData': r.rawData,
        'label': r.label,
        'scannedAt': r.scannedAt.toIso8601String(),
        'isFavorite': r.isFavorite,
      };

  ScanRecord _fromJson(Map<String, dynamic> json) => ScanRecord(
        id: json['id'] as String,
        type: ScanDataType.values.firstWhere((e) => e.name == json['type']),
        rawData: json['rawData'] as String,
        label: json['label'] as String,
        scannedAt: DateTime.parse(json['scannedAt'] as String),
        isFavorite: json['isFavorite'] as bool? ?? false,
      );
}
