import 'package:dartz/dartz.dart';
import 'package:story_app/common/failure.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

class AddStoryUseCase {
  final StoryRepository repository;

  AddStoryUseCase(this.repository);

  Future<Either<Failure, String>> execute(
    List<int> bytes,
    String fileName,
    String description,
    double? lat,
    double? lng,
  ) {
    return repository.addStory(
      bytes,
      fileName,
      description,
      lat,
      lng,
    );
  }
}
