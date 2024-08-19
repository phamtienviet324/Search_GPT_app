import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String _apiKey = ''; // Thay YOUR_API_KEY bằng API key của bạn
  final String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String?> askChatGPT(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': 'You are a helpful assistant.'},
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 50,
          'temperature': 0.7,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        return 'Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      print('Error during API call: $e');
      return 'Lỗi khi gọi API: ${e.toString()}';
    }
  }
}
