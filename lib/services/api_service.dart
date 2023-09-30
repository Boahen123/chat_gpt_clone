import 'dart:convert';
import 'dart:io';

import 'package:chat_gpt_clone/constants/api_constants.dart';
import 'package:chat_gpt_clone/models/ai_models_model.dart';
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
      print(models);

      return AIModelsModel.modelsFromAPI(modelSnapshot);
    } catch (error) {
      print('Error: $error');
      rethrow;
    } finally {
      client.close();
    }
  }
}
