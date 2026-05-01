import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class ApiService {
  // Use 10.0.2.2 for Android Emulator, or localhost for others
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  Future<List<ChatMessage>> getChatHistory() async {
    final response = await http.get(Uri.parse('$baseUrl/chat'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => ChatMessage.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load chat history');
    }
  }

  Future<ChatMessage> sendMessage(String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/chat'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'sender': 'user',
        'content': content,
      }),
    );

    if (response.statusCode == 200) {
      return ChatMessage.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to send message');
    }
  }
}
