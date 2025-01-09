import 'dart:io';

import 'package:flutter/material.dart';
import 'package:process_run/process_run.dart';

class Automation {
  Future<void> addPackagePubspec(
      {required String projectPath,
      required String packageName,
      required String packageVersion}) async {
    try {
      final pubspecFile = File('$projectPath/pubspec.yaml');
      if (!pubspecFile.existsSync()) {
        debugPrint('pubspec.yaml not found at $projectPath');
      }
      final pubspecLines = await pubspecFile.readAsLines();

      final insertPackageIndex =
          pubspecLines.indexWhere((line) => line.contains('dev_dependencies:'));

      if (insertPackageIndex == -1) {
        debugPrint('dev_dependencies section not found in pubspec.yaml');
      }
      pubspecLines.insert(
          insertPackageIndex, '  $packageName: ^$packageVersion');
      await pubspecFile.writeAsString(pubspecLines.join('\n'));
      await runPubget(directory: projectPath);
    } catch (e, stackTrace) {
      debugPrint("Error : $e\nStackTrace : $stackTrace");
    }
  }

  Future<void> runPubget({required String directory}) async {
    final shell = Shell(workingDirectory: directory);
    try {
      await shell.run('''flutter pub get''');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
