import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:story_app/data/models/add_story_response.dart';
import 'package:story_app/data/models/get_stories_response.dart';
import 'package:story_app/data/models/story_model.dart';

import '../../common/exception.dart';
import '../models/error_response.dart';

abstract class StoryRemoteDataSource {
  Future<String> addStory(
    List<int> bytes,
    String fileName,
    String description,
    String token,
    double? lat,
    double? lng,
  );
  Future<List<StoryModel>> getAllStories(int page, String token);
}

class StoryRemoteDataSourceImpl implements StoryRemoteDataSource {
  static const baseUrl = 'https://story-api.dicoding.dev/v1';

  final http.Client client;

  StoryRemoteDataSourceImpl({required this.client});

  @override
  Future<String> addStory(
    List<int> bytes,
    String fileName,
    String description,
    String token,
    double? lat,
    double? lng,
  ) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/stories'));

    final multiPartFile = http.MultipartFile.fromBytes(
      "photo",
      bytes,
      filename: fileName,
    );
    Map<String, String> fields = {};
    if (lat != null && lng != null) {
      fields= {
        "description": description,
        "lat": lat.toString(),
        "lon": lng.toString(),
      };
    } else {
       fields = {
        "description": description,
      };
    }

    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      "Content-type": "multipart/form-data",
    };

    request.files.add(multiPartFile);
    request.fields.addAll(fields);
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;

    final Uint8List responseList = await streamedResponse.stream.toBytes();
    final String response = String.fromCharCodes(responseList);

    if (statusCode == 201) {
      return AddStoryResponse.fromJson(json.decode(response)).message;
    } else {
      throw ServerException("Upload file error");
    }
  }

  @override
  Future<List<StoryModel>> getAllStories(int page, String token) async {
    final response = await client.get(
      Uri.parse('$baseUrl/stories?page=$page&size=10'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return GetStoriesResponse.fromJson(json.decode(response.body)).listStory;
    } else {
      throw ServerException(
          ErrorResponse.fromJson(json.decode(response.body)).message);
    }
  }
}
