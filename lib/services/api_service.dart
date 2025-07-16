// lib/services/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = "https://tu-api.com";

  Future<dynamic> getEquiposExternos() async {
    final response = await http.get(Uri.parse("$baseUrl/equipos"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al cargar los datos");
    }
  }
}
