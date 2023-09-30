import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_gpt_clone/constants/api_constants.dart';
import 'package:chat_gpt_clone/models/ai_models_model.dart';
import 'package:chat_gpt_clone/models/chat_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<AIModelsModel>> getModels() async {
    var client = http.Client();
    Map<String, String> headers = {
      "Authorization": "Bearer ${dotenv.env['OPENAI_API_KEY']}",
      "Content-Type": "application/json",
    };

    try {
      var response =
          await client.get(Uri.parse("$baseUrl/models"), headers: headers);

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']['message']);
      }

      List modelSnapshot = jsonResponse['data'];

      List<String> models = [];
      void addUp(e) {
        models.add(e['id']);
      }

      modelSnapshot.forEach(addUp);

      return AIModelsModel.modelsFromAPI(modelSnapshot);
    } catch (error) {
      log('Error: $error');
      rethrow;
    } finally {
      client.close();
    }
  }

  static Future<List<ChatModel>> sendPrompt(String model, String prompt) async {
    var client = http.Client();
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${dotenv.env['OPENAI_API_KEY']}",
    };

    Map<String, dynamic> body = {
      "model": model,
      "prompt": prompt,
      "max_tokens": 100,
      "temperature": 0
    };

    try {
      var response = await client.post(Uri.parse("$baseUrl/completions"),
          headers: headers, body: jsonEncode(body));

      Map jsonResponse = jsonDecode(response.body);

      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']['message']);
      }

      List modelSnapshot = jsonResponse['choices'];

      late List<ChatModel> chatList;

      if (modelSnapshot.isNotEmpty) {
        chatList = List.generate(modelSnapshot.length, (index) {
          return ChatModel(chatIndex: 1, msg: modelSnapshot[index]["text"]);
        });
      }

      return chatList;
    } catch (error) {
      log('Error caught to console: $error');
      rethrow;
    } finally {
      client.close();
    }
  }
}
