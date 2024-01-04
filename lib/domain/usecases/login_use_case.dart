 import 'package:dartz/dartz.dart';
import 'package:story_app/domain/repositories/auth_repository.dart';

import '../../common/failure.dart';

class LoginUseCase {
   final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, String>> execute(
    String email,
    password,
  ) {
    return repository.login(email, password);
  }
}