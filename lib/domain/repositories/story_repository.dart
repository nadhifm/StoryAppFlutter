import 'package:dartz/dartz.dart';
import 'package:story_app/common/failure.dart';
import 'package:story_app/domain/entities/story.dart';

abstract class StoryRepository {
  Future<Either<Failure, String>> addStory(
    List<int> bytes,
    String fileName,
    String description,
    double? lat,
    double? lng,
  );
  Future<Either<Failure, List<Story>>> getAllStories(int page);
}
