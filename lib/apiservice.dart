// api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.0.109:8000/api';

  static Future<List<dynamic>> getServices() async {
    final response = await http.get(Uri.parse('$baseUrl/services'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load services');
    }
  }

  static Future<List<dynamic>> getLocations(int serviceId) async {
    final response = await http.get(Uri.parse('$baseUrl/locations/$serviceId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load locations for service $serviceId');
    }
  }

  static Future<List<dynamic>> getTechnicians(int serviceId, int locationId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/technicians/$serviceId/$locationId'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load technicians');
    }
  }
}