import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('current_user');
    if (userData != null) {
      _currentUser = User.fromJson(json.decode(userData));
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final usersData = prefs.getString('users') ?? '[]';
      final List<dynamic> usersJson = json.decode(usersData);
      final users = usersJson.map((u) => User.fromJson(u)).toList();

      final user = users.firstWhere(
        (u) => u.email == email && u.password == password,
        orElse: () => throw Exception('Invalid email or password'),
      );

      _currentUser = user;
      await prefs.setString('current_user', json.encode(user.toJson()));
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final usersData = prefs.getString('users') ?? '[]';
      final List<dynamic> usersJson = json.decode(usersData);
      final users = usersJson.map((u) => User.fromJson(u)).toList();

      if (users.any((u) => u.email == email)) {
        throw Exception('Email already registered');
      }

      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        password: password,
      );

      users.add(newUser);
      await prefs.setString('users', json.encode(users.map((u) => u.toJson()).toList()));

      _currentUser = newUser;
      await prefs.setString('current_user', json.encode(newUser.toJson()));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateProfile(String name, String? profileImage) async {
    if (_currentUser == null) return;

    final updatedUser = User(
      id: _currentUser!.id,
      name: name,
      email: _currentUser!.email,
      password: _currentUser!.password,
      profileImage: profileImage,
    );

    final prefs = await SharedPreferences.getInstance();

    // Update in users list
    final usersData = prefs.getString('users') ?? '[]';
    final List<dynamic> usersJson = json.decode(usersData);
    final users = usersJson.map((u) => User.fromJson(u)).toList();
    final index = users.indexWhere((u) => u.id == _currentUser!.id);
    if (index != -1) {
      users[index] = updatedUser;
      await prefs.setString('users', json.encode(users.map((u) => u.toJson()).toList()));
    }

    // Update current user
    _currentUser = updatedUser;
    await prefs.setString('current_user', json.encode(updatedUser.toJson()));
    notifyListeners();
  }
}
