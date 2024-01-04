import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_app/data/models/error_response.dart';
import 'package:story_app/data/models/login_response.dart';

import '../../common/exception.dart';
import '../models/register_response.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(String email, password);
  Future<RegisterResponse> register(String name, email, password);
}

class AuthRemoteDateSourceImpl implements AuthRemoteDataSource {
  static const baseUrl = 'https://story-api.dicoding.dev/v1';

  final http.Client client;

  AuthRemoteDateSourceImpl({required this.client});

  @override
  Future<LoginResponse> login(String email, password) async {
    final Map<String, dynamic> jsonData = {
      'email': email,
      'password': password,
    };

    final response = await client.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(jsonData),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException(ErrorResponse.fromJson(json.decode(response.body)).message);
    }
  }

  @override
  Future<RegisterResponse> register(String name, email, password) async {
    final Map<String, dynamic> jsonData = {
      'name': name,
      'email': email,
      'password': password,
    };

    final response = await client.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(jsonData),
    );

    if (response.statusCode == 201) {
      return RegisterResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException(ErrorResponse.fromJson(json.decode(response.body)).message);
    }
  }
}
