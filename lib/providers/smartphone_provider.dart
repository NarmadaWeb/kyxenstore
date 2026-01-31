import 'package:flutter/material.dart';
import '../models/smartphone.dart';
import '../services/api_service.dart';

class SmartphoneProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Smartphone> _smartphones = [];
  bool _isLoading = false;
  String _error = '';

  List<Smartphone> get smartphones => _smartphones;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchSmartphones() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _smartphones = await _apiService.fetchSmartphones();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addSmartphone(Smartphone smartphone) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final newSmartphone = await _apiService.addSmartphone(smartphone);
      _smartphones.add(newSmartphone);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateSmartphone(Smartphone smartphone) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final updatedSmartphone = await _apiService.updateSmartphone(smartphone);
      final index = _smartphones.indexWhere((s) => s.id == smartphone.id);
      if (index != -1) {
        _smartphones[index] = updatedSmartphone;
      }
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteSmartphone(String id) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _apiService.deleteSmartphone(id);
      _smartphones.removeWhere((s) => s.id == id);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
