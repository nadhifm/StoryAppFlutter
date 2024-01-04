import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'error_response.g.dart';

@JsonSerializable()
class ErrorResponse extends Equatable {
  final bool error;
  final String message;

  const ErrorResponse({required this.error, required this.message});

  factory ErrorResponse.fromJson(json) => _$ErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);

  @override
  List<Object?> get props => [error, message];
}
