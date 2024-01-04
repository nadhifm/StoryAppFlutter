import 'package:dartz/dartz.dart';
import 'package:story_app/common/failure.dart';
import 'package:story_app/domain/entities/story.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

class GetAllStoriesUseCase {
  final StoryRepository repository;

  GetAllStoriesUseCase(this.repository);

  Future<Either<Failure, List<Story>>> execute(int page) {
    return repository.getAllStories(page);
  }
}