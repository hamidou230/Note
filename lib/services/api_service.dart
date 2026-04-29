import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://jsonplaceholder.typicode.com";

  Future<List<dynamic>> getAllNotes() async {
    final response = await http.get(Uri.parse("$baseUrl/posts"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur API");
    }
  }

  Future<bool> createNote(String title, String body) async {
    final response = await http.post(
      Uri.parse("$baseUrl/posts"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"title": title, "body": body}),
    );

    return response.statusCode == 201;
  }

  Future<bool> deleteNote(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/posts/$id"),
    );

    return response.statusCode == 200;
  }
}