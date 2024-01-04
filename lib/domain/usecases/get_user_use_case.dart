 import 'package:dartz/dartz.dart';
import 'package:story_app/domain/entities/user.dart';
import 'package:story_app/domain/repositories/auth_repository.dart';

import '../../common/failure.dart';

class GetUserUseCase {
   final AuthRepository repository;

  GetUserUseCase(this.repository);

  Future<Either<Failure, User>> execute() {
    return repository.getUser();
  }
}