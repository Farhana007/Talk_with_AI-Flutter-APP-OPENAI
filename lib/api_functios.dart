import 'dart:convert';

import 'package:http/http.dart' as http;

String apiKey = "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";

class ApiServices {
  static String baseUrl = "https://api.openai.com/v1/completions";

  static Map<String, String> header = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey'
  };

  //sendMessageModel

  static sendMessage(String? message) async {
    final result = await http.post(Uri.parse(baseUrl),
        headers: header,
        body: jsonEncode({
          "model": "text-davinci-003",
          "prompt": '$message',
          "temperature": 0,
          "max_tokens": 100,
          "top_p": 1,
          "frequency_penalty": 0.0,
          "presence_penalty": 0.0,
          "stop": ["Human:", " AI:"]
        }));

    if (result.statusCode == 200) {
      var data = jsonDecode(result.body.toString());
      var returnMessage = data['choices'][0]['text'];

      return returnMessage;
    } else {
      print("Failed To fetch data");
    }
  }
}
