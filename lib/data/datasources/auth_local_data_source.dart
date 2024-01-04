import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/models/user_model.dart';

import '../../common/exception.dart';

abstract class AuthLocalDataSource {
  Future<bool> isLoggedIn();
  Future<bool> login(String name, email, token);
  Future<bool> logout();
  Future<UserModel> getUser();
  Future<String> getToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences preferences;

  AuthLocalDataSourceImpl({required this.preferences});

  final String stateKey = "state";
  final String tokenKey = "token";
  final String userKey = "user";

  @override
  Future<UserModel> getUser() async {
    try {
      final jsonUser = preferences.getString(userKey);
      return jsonUser != null
          ? UserModel.fromJson(json.decode(jsonUser))
          : const UserModel(name: "name", email: "email");
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return preferences.getBool(stateKey) ?? false;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<bool> login(String name, email, token) async {
    try {
      Map<String, dynamic> jsonUser = {
        'name': name,
        'email': email,
      };
      String user = json.encode(jsonUser);
      await preferences.setString(userKey, user);
      await preferences.setString(tokenKey, token);
      await preferences.setBool(stateKey, true);
      return true;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await preferences.setBool(stateKey, false);
      await preferences.setString(tokenKey, "");
      await preferences.setString(userKey, "");
      return true;
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> getToken() async {
    try {
      return preferences.getString(tokenKey) ?? "";
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
