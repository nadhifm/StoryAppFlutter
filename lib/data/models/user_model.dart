import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:story_app/domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String name;
  final String email;

  const UserModel({
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  User toEntity() => User(
        name: name,
        email: email,
      );

  @override
  List<Object> get props => [];
}
