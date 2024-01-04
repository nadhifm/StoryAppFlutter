import 'package:dartz/dartz.dart';
import 'package:story_app/domain/entities/user.dart';

import '../../common/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> isLoggedIn();
  Future<Either<Failure, String>> login(String email, password);
  Future<Either<Failure, String>> register(String name, email, password);
  Future<Either<Failure, bool>> logout();
  Future<Either<Failure, User>> getUser();
}
