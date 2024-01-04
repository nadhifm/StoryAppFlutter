 import 'package:dartz/dartz.dart';
import 'package:story_app/domain/repositories/auth_repository.dart';

import '../../common/failure.dart';

class RegisterUseCase {
   final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, String>> execute(
    String name,
    email,
    password,
  ) {
    return repository.register(name, email, password,);
  }
}