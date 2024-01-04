import 'package:flutter/cupertino.dart';
import 'package:story_app/common/state_enum.dart';
import 'package:story_app/domain/usecases/register_use_case.dart';

class RegisterNotifier extends ChangeNotifier {
  final RegisterUseCase _registerUseCase;

  RegisterNotifier(this._registerUseCase);

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  String _message = '';
  String get message => _message;

  Future<void> register(String name, email, password) async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await _registerUseCase.execute(name, email, password);

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
