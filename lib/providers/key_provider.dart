import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiKeyProvider =
    StateNotifierProvider<ApiKeyProvider, String>((ref) => ApiKeyProvider());

class ApiKeyProvider extends StateNotifier<String> {
  ApiKeyProvider() : super('');

  void getProjectApiKey({required String apiKey}) async {
    state = apiKey;
  }
}
