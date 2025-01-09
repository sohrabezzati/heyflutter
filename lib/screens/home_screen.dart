import 'map_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heyflutter/providers/directory_provider.dart';

import '../constants/constants.dart';
import '../providers/state_provider.dart';
import '../services/automation.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});
  final automation = Automation();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final directory = ref.watch(directoryProvider);
    final directoryNotifier = ref.read(directoryProvider.notifier);
    final state = ref.watch(stateProvider);
    final stateNotifier = ref.read(stateProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('HeyFlutter'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              style: bottomStyle,
              onPressed: () {
                directoryNotifier.getProjectDirectory();
              },
              child: const Text('Select Project Directory'),
            ),
            const SizedBox(height: 16),
            Text(directory),
            if (directory != '' &&
                directory != 'Please Select Project Directory')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: bottomStyle,
                    onPressed: () async {
                      await automation.addPackagePubspec(
                          projectPath: directory,
                          packageName: 'google_maps_flutter',
                          packageVersion: '2.10.0');
                      await promptForApiKey(context, ref);
                      stateNotifier.updateState('google map added');
                    },
                    child: const Text('Add Google map to project'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            if (state == 'google map added')
              ElevatedButton(
                style: bottomStyle,
                onPressed: () async {
                  await automation.addMapView(
                    directory: directory,
                  );
                  await automation.updateHomeScreen(directory: directory);
                  stateNotifier.updateState('map view added');
                },
                child: const Text('Add Map View and Build Android'),
              ),
            state == 'map view added'
                ? const SizedBox(
                    height: 300,
                    child: MapSample(),
                    // add view here
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<String?> promptForApiKey(BuildContext context, WidgetRef ref) async {
    final directory = ref.watch(directoryProvider);
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Google Maps API Key'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'API Key'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                debugPrint('don\'t ptovided an api key!');
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await automation.updateAnodroidManifist(
                    projectPath: directory, apiKey: controller.text);
                await automation.updateAppDelegate(
                    projectPath: directory, apiKey: controller.text);
                debugPrint('an api key added');
                Navigator.pop(context, controller.text);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
