import 'package:flutter/cupertino.dart';
import 'package:story_app/domain/usecases/get_login_status_use_case.dart';

import '../../common/state_enum.dart';

class SplashNotifier extends ChangeNotifier {
  final GetLoginStatusUseCase _getLoginStatusUseCase;

  SplashNotifier(this._getLoginStatusUseCase);
  
  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> getLoginStatus() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await _getLoginStatusUseCase.execute();

    result.fold(
      (failure) {
        _state = RequestState.Error;
        notifyListeners();
      },
      (result) {
        if (result) {
          _state = RequestState.Loaded;
          _isLoggedIn = result;
          notifyListeners();
        }
      },
    );
  }
}