import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_result.freezed.dart';

enum ScanResultType {
  barcode,
  qrCode,
}

@freezed
class ScanResult with _$ScanResult {
  const factory ScanResult({
    required String barcode,
    required DateTime timestamp,
    required ScanResultType type,
    String? drinkId,
    String? drinkName,
    bool? found,
  }) = _ScanResult;
}