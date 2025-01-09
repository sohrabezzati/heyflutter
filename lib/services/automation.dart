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

  Future<void> addMapView({required String directory}) async {
    final mapViewFile = File('$directory/lib/screens/map_view.dart');
    try {
      await mapViewFile.create(recursive: true);
      debugPrint(
          'File map_view created successfully in ${mapViewFile.absolute.path}.');
    } catch (e) {
      debugPrint('Error creating file: $e');
    }
    const String mapViewCode = '''
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatelessWidget {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  const MapSample({super.key});

  @override
  Widget build(BuildContext context) {
    return const GoogleMap(
      mapType: MapType.hybrid,
      initialCameraPosition: _kGooglePlex,
    );
  }
}
''';
    if (!mapViewFile.existsSync()) {
      throw Exception("AppDelegate.swift not found.");
    }

    try {
      await mapViewFile.writeAsString(mapViewCode);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateHomeScreen({required String directory}) async {
    try {
      final homeScreenFile =
          File('$directory/lib/screens/mobile_home_screen.dart');
      if (!homeScreenFile.existsSync()) {
        throw Exception('home screen not found!');
      }

      final homeScreenASlines = await homeScreenFile.readAsLines();

      final indexToAddMapView = homeScreenASlines
          .indexWhere((line) => line.contains('// add map view here'));
      homeScreenASlines.insert(0, '''import 'map_view.dart';''');
      homeScreenASlines.insert(indexToAddMapView, 'child: MapSample(),');

      homeScreenFile.writeAsString(homeScreenASlines.join('\n'));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
