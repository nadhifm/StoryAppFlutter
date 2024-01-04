 import 'package:dartz/dartz.dart';
import 'package:story_app/domain/repositories/auth_repository.dart';

import '../../common/failure.dart';

class LogoutUseCase {
   final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, bool>> execute() {
    return repository.logout();
  }
}