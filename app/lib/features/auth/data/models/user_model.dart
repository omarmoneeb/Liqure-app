import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    String? username,
    String? avatar,
    DateTime? created,
    DateTime? updated,
    @Default(false) bool verified,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  
  const UserModel._();
  
  factory UserModel.fromPocketBase(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String?,
      avatar: json['avatar'] as String?,
      created: json['created'] != null ? DateTime.parse(json['created']) : null,
      updated: json['updated'] != null ? DateTime.parse(json['updated']) : null,
      verified: json['verified'] as bool? ?? false,
    );
  }
  
  User toEntity() {
    return User(
      id: id,
      email: email,
      username: username,
      avatar: avatar,
      created: created,
      updated: updated,
      verified: verified,
    );
  }
  
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      username: user.username,
      avatar: user.avatar,
      created: user.created,
      updated: user.updated,
      verified: user.verified,
    );
  }
}