import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/smartphone.dart';

class ApiService {
  static const String baseUrl = 'https://693cf361b762a4f15c41dd20.mockapi.io/hp';

  Future<List<Smartphone>> fetchSmartphones() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Smartphone.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load smartphones');
    }
  }

  Future<Smartphone> addSmartphone(Smartphone smartphone) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(smartphone.toJson()),
    );

    if (response.statusCode == 201) {
      return Smartphone.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add smartphone');
    }
  }

  Future<Smartphone> updateSmartphone(Smartphone smartphone) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${smartphone.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(smartphone.toJson()),
    );

    if (response.statusCode == 200) {
      return Smartphone.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update smartphone');
    }
  }

  Future<void> deleteSmartphone(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete smartphone');
    }
  }
}
