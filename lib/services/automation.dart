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
      await runCommand(directory: projectPath, command: '''flutter pub get''');
    } catch (e, stackTrace) {
      debugPrint("Error : $e\nStackTrace : $stackTrace");
    }
  }

  Future<void> runCommand(
      {required String directory, required String command}) async {
    final shell = Shell(workingDirectory: directory);
    try {
      await shell.run(command);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateAnodroidManifist(
      {required String projectPath, required String apiKey}) async {
    try {
      final manifestFile =
          File('$projectPath/android/app/src/main/AndroidManifest.xml');
      if (!manifestFile.existsSync()) {
        debugPrint('pubspec.yaml not found at $projectPath');
      }

      final lines = await manifestFile.readAsLines();
      final applicationTagIndex =
          lines.indexWhere((line) => line.contains('</application>'));

      if (applicationTagIndex == -1) {
        throw Exception('</application> tag not found in AndroidManifest.xml');
      }

      lines.insert(
        applicationTagIndex,
        '  <meta-data\n        android:name="com.google.android.geo.API_KEY"\n        android:value="$apiKey" />',
      );
      await manifestFile.writeAsString(lines.join('\n'));
    } catch (e, stackTrace) {
      debugPrint("Error in updateAndroidManifest: $e");
      debugPrint("StackTrace: $stackTrace");
    }
  }

  Future<void> updateAppDelegate(
      {required String projectPath, required String apiKey}) async {
    try {
      final appDelegateFile = File('$projectPath/ios/Runner/AppDelegate.swift');

      if (!appDelegateFile.existsSync()) {
        throw Exception("AppDelegate.swift not found.");
      }

      final lines = await appDelegateFile.readAsLines();
      final importIndex = lines.indexWhere((line) => line.contains('@main'));
      final addKeyIndex = lines
          .indexWhere((line) => line.contains('GeneratedPluginRegistrant'));

      if (importIndex == -1 || addKeyIndex == -1) {
        throw Exception('Necessary sections not found in AppDelegate.swift');
      }

      lines.insert(importIndex, 'import GoogleMaps');
      lines.insert(addKeyIndex + 1, 'GMSServices.provideAPIKey("$apiKey")');

      await appDelegateFile.writeAsString(lines.join('\n'));
    } catch (e, stackTrace) {
      debugPrint("Error in updateAppDelegate: $e");
      debugPrint("StackTrace: $stackTrace");
    }
  }
}
