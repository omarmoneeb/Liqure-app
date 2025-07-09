import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? username,
    String? avatar,
    DateTime? created,
    DateTime? updated,
    @Default(false) bool verified,
  }) = _User;
}