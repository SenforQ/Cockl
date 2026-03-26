import 'dart:convert';
import 'dart:io';

class ZhipuAiService {
  ZhipuAiService({String? apiKey})
      : _apiKey = apiKey ??
            const String.fromEnvironment('ZHIPU_API_KEY', defaultValue: _embeddedApiKey);

  static const String _embeddedApiKey = '37b9dc1b9a5949fc96432f0376abe6f6.JME6CR3cHBSqDmde';

  final String _apiKey;

  bool get isConfigured => _apiKey.trim().isNotEmpty;

  Future<String> chat({
    required String userMessage,
  }) async {
    if (!isConfigured) {
      throw StateError('Missing ZHIPU_API_KEY');
    }

    final client = HttpClient();
    try {
      final request = await client.postUrl(
        Uri.parse('https://open.bigmodel.cn/api/paas/v4/chat/completions'),
      );
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $_apiKey');
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
      request.write(
        jsonEncode({
          'model': 'glm-4-flash',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a professional fitness assistant. Reply in concise English. Give safe and practical workout advice.',
            },
            {'role': 'user', 'content': userMessage},
          ],
          'temperature': 0.7,
        }),
      );
      final response = await request.close();
      final body = await utf8.decodeStream(response);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException('Zhipu API error ${response.statusCode}: $body');
      }
      final json = jsonDecode(body) as Map<String, dynamic>;
      final choices = json['choices'];
      if (choices is List && choices.isNotEmpty) {
        final first = choices.first;
        if (first is Map<String, dynamic>) {
          final message = first['message'];
          if (message is Map<String, dynamic>) {
            final content = message['content'];
            if (content is String && content.trim().isNotEmpty) {
              return content.trim();
            }
          }
        }
      }
      throw const FormatException('Invalid response format from Zhipu API');
    } finally {
      client.close(force: true);
    }
  }
}
