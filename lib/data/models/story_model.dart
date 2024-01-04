import 'package:equatable/equatable.dart';
import 'package:story_app/domain/entities/story.dart';
import 'package:json_annotation/json_annotation.dart';

part 'story_model.g.dart';

@JsonSerializable()
class StoryModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String photoUrl;
  final DateTime createdAt;
  final double? lat;
  final double? lon;

  const StoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    required this.lat,
    required this.lon,
  });

  factory StoryModel.fromJson(json) => _$StoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoryModelToJson(this);

  Story toEntity() => Story(
        id: id,
        name: name,
        description: description,
        photoUrl: photoUrl,
        createdAt: createdAt,
        lat: lat,
        lon: lon,
      );

  @override
  List<Object> get props =>
      [id, name, description, photoUrl, createdAt];
}
