import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/common/state_enum.dart';
import 'package:story_app/domain/usecases/add_story_use_case.dart';
import 'package:geocoding/geocoding.dart' as geo;

class AddStoryNotifier extends ChangeNotifier {
  final AddStoryUseCase _addStoryUseCase;

  AddStoryNotifier(this._addStoryUseCase);

  String? _imagePath;
  String? get imagePath => _imagePath;

  XFile? _imageFile;
  XFile? get imageFile => _imageFile;

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  String _message = '';
  String get message => _message;

  LatLng? _latLng;
  LatLng? get latLng => _latLng;

  geo.Placemark? _placemark;
  geo.Placemark? get placemark => _placemark;

  Future<void> addStory(String description) async {
    _state = RequestState.Loading;
    notifyListeners();

    final fileName = imageFile?.name;
    final bytes = await imageFile?.readAsBytes();

    if (fileName == null || bytes == null) {
      _state = RequestState.Error;
      _message = "Pilih Gambar Terlebih Dahulu";
      notifyListeners();
    } else {
      final result = await _addStoryUseCase.execute(
        bytes,
        fileName,
        description,
        _latLng?.latitude,
        _latLng?.longitude,
      );

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

  void setImagePath(String? value) {
    _imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    _imageFile = value;
    notifyListeners();
  }

  void setLatLng(LatLng latLng) {
    _latLng = latLng;
    notifyListeners();
  }

  void setPlacemark(geo.Placemark placemark) {
    _placemark = placemark;
    notifyListeners();
  }
}