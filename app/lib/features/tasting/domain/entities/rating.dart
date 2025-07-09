import 'package:freezed_annotation/freezed_annotation.dart';

part 'rating.freezed.dart';

@freezed
class Rating with _$Rating {
  const factory Rating({
    required String id,
    required String userId,
    required String drinkId,
    required double score, // 1.0 to 5.0
    String? note,
    List<String>? photos,
    DateTime? created,
    DateTime? updated,
  }) = _Rating;
}