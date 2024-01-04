import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_result_model.g.dart';

@JsonSerializable()
class LoginResultModel extends Equatable {
  final String userId;
  final String name;
  final String token;

  const LoginResultModel(
      {required this.userId, required this.name, required this.token});

  factory LoginResultModel.fromJson(json) => _$LoginResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResultModelToJson(this);
  
  @override
  List<Object?> get props => [userId, name, token];
}
