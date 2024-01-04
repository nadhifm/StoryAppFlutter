import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_story_response.g.dart';

@JsonSerializable()
class AddStoryResponse extends Equatable {
  final bool error;
  final String message;

  const AddStoryResponse({required this.error, required this.message});

  factory AddStoryResponse.fromJson(json) => _$AddStoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddStoryResponseToJson(this);

  @override
  List<Object?> get props => [error, message];
}
