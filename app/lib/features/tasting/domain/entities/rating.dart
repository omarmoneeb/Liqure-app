import 'package:freezed_annotation/freezed_annotation.dart';

part 'rating.freezed.dart';

@freezed
class Rating with _$Rating {
  const factory Rating({
    required String id,
    required String userId,
    required String drinkId,
    required double rating, // 0.5 to 5.0 (half-star support)
    String? notes,
    List<String>? photos,
    DateTime? created,
    DateTime? updated,
  }) = _Rating;
}