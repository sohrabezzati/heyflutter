import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stateProvider =
    StateNotifierProvider<AppState, String>((ref) => AppState());

class AppState extends StateNotifier<String> {
  AppState() : super('');
  void updateState(String appState) {
    debugPrint(appState);
    state = appState;
  }
}
