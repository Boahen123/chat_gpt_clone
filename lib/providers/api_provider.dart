import 'package:chat_gpt_clone/models/ai_models_model.dart';
import 'package:chat_gpt_clone/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiProvider = Provider<ApiService>((ref) => ApiService());

final modelsDataProvider = FutureProvider<List<AIModelsModel>>(
  (ref) {
    return ref.read(apiProvider).getModels();
  },
);
