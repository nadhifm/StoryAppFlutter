import 'package:flutter/cupertino.dart';
import 'package:story_app/domain/entities/user.dart';
import 'package:story_app/domain/usecases/get_user_use_case.dart';
import 'package:story_app/domain/usecases/logout_use_case.dart';

import '../../common/state_enum.dart';

class ProfileNotifier extends ChangeNotifier{
  final GetUserUseCase getUserUseCase;
  final LogoutUseCase logoutUseCase;

  ProfileNotifier({required this.getUserUseCase, required this.logoutUseCase});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  User _user = const User(name: "name", email: "email");
  User get user => _user;

  Future<void> getUser() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getUserUseCase.execute();

    result.fold(
          (failure) {
        _state = RequestState.Error;
        notifyListeners();
      },
          (result) {
        _state = RequestState.Loaded;
        _user = result;
        notifyListeners();
      },
    );
  }

  Future<void> logout() async {
    await logoutUseCase.execute();
    notifyListeners();
  }
}