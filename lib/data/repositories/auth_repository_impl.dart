import 'dart:io';

import 'package:story_app/common/exception.dart';
import 'package:story_app/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:story_app/data/datasources/auth_remote_data_source.dart';
import 'package:story_app/data/datasources/auth_local_data_source.dart';
import 'package:story_app/domain/entities/user.dart';
import 'package:story_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, User>> getUser() async {
    try {
      final result = await localDataSource.getUser();
      return Right(result.toEntity());
    } on DatabaseException {
      return const Left(DatabaseFailure(''));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final result = await localDataSource.isLoggedIn();
      return Right(result);
    } on DatabaseException {
      return const Left(DatabaseFailure(''));
    }
  }

  @override
  Future<Either<Failure, String>> login(String email, password) async {
    try {
      final result = await remoteDataSource.login(email, password);
      await localDataSource.login(
          result.loginResult.name, email, result.loginResult.token);
      return Right(result.message);
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    } on DatabaseException {
      return const Left(DatabaseFailure(''));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> register(String name, email, password) async {
    try {
      final result = await remoteDataSource.register(name, email, password);
      return Right(result.message);
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    } on DatabaseException {
      return const Left(DatabaseFailure(''));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await localDataSource.logout();
      return Right(result);
    } on DatabaseException {
      return const Left(DatabaseFailure(''));
    }
  }
}
