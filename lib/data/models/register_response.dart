import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponse extends Equatable {
  final bool error;
  final String message;

  const RegisterResponse({required this.error, required this.message});

  factory RegisterResponse.fromJson(json) => _$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);

  @override
  List<Object?> get props => [error, message];
}
