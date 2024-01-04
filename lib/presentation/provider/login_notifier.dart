import 'package:flutter/material.dart';
import 'package:story_app/domain/usecases/login_use_case.dart';

import '../../common/state_enum.dart';

class LoginNotifier extends ChangeNotifier {
  final LoginUseCase _loginUseCase;

  LoginNotifier(this._loginUseCase);
  
  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  String _message = '';
  String get message => _message;

  Future<void> login(String email, password) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await _loginUseCase.execute(email, password);

    result.fold(
      (failure) {
        _state = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (message) {
        _state = RequestState.Loaded;
        _message = message;
        notifyListeners();
      },
    );
  }
}