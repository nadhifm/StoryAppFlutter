import 'package:flutter/material.dart';
import 'package:story_app/domain/entities/story.dart';
import 'package:story_app/domain/usecases/get_all_stories_use_case.dart';

import '../../common/state_enum.dart';

class StoryListNotifier extends ChangeNotifier {
  final GetAllStoriesUseCase _getAllStoriesUseCase;

  StoryListNotifier(this._getAllStoriesUseCase);

  final _stories = <Story>[];
  List<Story> get stories => _stories;
  
  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  String _message = '';
  String get message => _message;

  int? _pageItems = 1;
  int? get pageItems => _pageItems;

  Future<void> fetchAllStories(bool isUpdated) async {
    if (isUpdated) {
      _stories.clear();
      _pageItems = 1;
    }

    if (_pageItems == 1) {
      _state = RequestState.Loading;
      notifyListeners();
    }

    final result = await _getAllStoriesUseCase.execute(_pageItems!);
    result.fold(
      (failure) {
        _state = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (storiesData) {
        if (storiesData.length < 10) {
          _pageItems = null;
        } else {
          _pageItems = _pageItems! + 1;
        }

        _state = RequestState.Loaded;
        _stories.addAll(storiesData);
        notifyListeners();
      },
    );
  }
}