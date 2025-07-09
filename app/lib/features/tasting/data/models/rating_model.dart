import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/rating.dart';

part 'rating_model.freezed.dart';
part 'rating_model.g.dart';

@freezed
class RatingModel with _$RatingModel {
  const factory RatingModel({
    required String id,
    required String user,
    required String drink,
    required double score,
    String? note,
    List<String>? photos,
    DateTime? created,
    DateTime? updated,
  }) = _RatingModel;

  factory RatingModel.fromJson(Map<String, dynamic> json) => _$RatingModelFromJson(json);
  
  const RatingModel._();
  
  factory RatingModel.fromPocketBase(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'] as String,
      user: json['user'] as String,
      drink: json['drink'] as String,
      score: (json['score'] as num).toDouble(),
      note: json['note'] as String?,
      photos: json['photos'] != null 
        ? List<String>.from(json['photos'] as List)
        : null,
      created: json['created'] != null ? DateTime.parse(json['created']) : null,
      updated: json['updated'] != null ? DateTime.parse(json['updated']) : null,
    );
  }
  
  Rating toEntity() {
    return Rating(
      id: id,
      userId: user,
      drinkId: drink,
      score: score,
      note: note,
      photos: photos,
      created: created,
      updated: updated,
    );
  }
  
  factory RatingModel.fromEntity(Rating rating) {
    return RatingModel(
      id: rating.id,
      user: rating.userId,
      drink: rating.drinkId,
      score: rating.score,
      note: rating.note,
      photos: rating.photos,
      created: rating.created,
      updated: rating.updated,
    );
  }
}