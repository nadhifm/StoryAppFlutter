import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'login_result_model.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse extends Equatable {
  final bool error;
  final String message;
  final LoginResultModel loginResult;

  const LoginResponse(
      {required this.error, required this.message, required this.loginResult});

  factory LoginResponse.fromJson(json) => _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  @override
  List<Object?> get props => [error, message, loginResult];
}
