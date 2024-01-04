import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:story_app/common/failure.dart';
import 'package:story_app/data/datasources/auth_local_data_source.dart';
import 'package:story_app/data/datasources/story_remote_data_source.dart';
import 'package:story_app/domain/entities/story.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

import '../../common/exception.dart';

class StoryRepositoryImpl extends StoryRepository {
  final StoryRemoteDataSource remoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  StoryRepositoryImpl({
    required this.remoteDataSource,
    required this.authLocalDataSource,
  });
  @override
  Future<Either<Failure, String>> addStory(
    List<int> bytes,
    String fileName,
    String description,
    double? lat,
    double? lng,
  ) async {
    try {
      final token = await authLocalDataSource.getToken();
      final result = await remoteDataSource.addStory(
        bytes,
        fileName,
        description,
        token,
        lat,
        lng,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Story>>> getAllStories(
    int page,
  ) async {
    try {
      final token = await authLocalDataSource.getToken();
      final result = await remoteDataSource.getAllStories(page, token);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}
