import 'package:flutter/material.dart';
import 'package:searchapp/OpenAI/openai_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';
  final OpenAIService _openAIService = OpenAIService();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final question = _controller.text;
    if (question.isEmpty) {
      setState(() {
        _result = 'Vui lòng nhập câu hỏi.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _result = ''; // Clear the result while loading
    });

    try {
      final response = await _openAIService.askChatGPT(question);
      setState(() {
        _result = response ?? 'Lỗi khi gọi API';
      });
    } catch (e) {
      setState(() {
        _result = 'Lỗi khi gọi API: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat GPT 3.5 Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nhập câu hỏi',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _handleSubmit(), // Gọi API khi nhấn Enter
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleSubmit,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Submit'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _result,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
