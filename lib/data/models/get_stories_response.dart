import 'package:equatable/equatable.dart';
import 'package:story_app/data/models/story_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_stories_response.g.dart';

@JsonSerializable()
class GetStoriesResponse extends Equatable {
  final bool error;
  final String message;
  final List<StoryModel> listStory;

  const GetStoriesResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory GetStoriesResponse.fromJson(json) => _$GetStoriesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetStoriesResponseToJson(this);

  @override
  List<Object?> get props => [error, message, listStory];
}
