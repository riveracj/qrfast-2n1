enum ScanDataType { url, wifi, product, text, unknown }

class ScanRecord {
  final String id;
  final ScanDataType type;
  final String rawData;
  final String label;
  final DateTime scannedAt;
  final bool isFavorite;

  ScanRecord({
    required this.id,
    required this.type,
    required this.rawData,
    required this.label,
    required this.scannedAt,
    this.isFavorite = false,
  });

  ScanRecord copyWith({bool? isFavorite}) {
    return ScanRecord(
      id: id,
      type: type,
      rawData: rawData,
      label: label,
      scannedAt: scannedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toCsvRow() {
    return {
      'ID': id,
      'Type': type.name,
      'Data': rawData,
      'Label': label,
      'Date': scannedAt.toIso8601String(),
      'Favorite': isFavorite.toString(),
    };
  }

  static List<String> csvHeaders() {
    return ['ID', 'Type', 'Data', 'Label', 'Date', 'Favorite'];
  }
}
