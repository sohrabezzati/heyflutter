import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/automation.dart';

final prograseProvider = StateNotifierProvider<PrograseProvider, String>(
    (ref) => PrograseProvider());

class PrograseProvider extends StateNotifier<String> {
  PrograseProvider() : super('');
  final automation = Automation();
  void addPackageToPubspec({required String directory}) async {
    state = 'Adding package to pubspec.yaml';
    await automation.addPackagePubspec(
        projectPath: directory,
        packageName: 'google_maps_flutter',
        packageVersion: '2.10.0');
    state = 'Added package to pubspec.yaml';
  }
}
