import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heyflutter/providers/directory_provider.dart';
import 'package:heyflutter/providers/prograse_provider.dart';

import '../constants/constants.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final directory = ref.watch(directoryProvider);
    final directoryNotifier = ref.read(directoryProvider.notifier);

    final prograse = ref.watch(prograseProvider);
    final prograseNofier = ref.read(prograseProvider.notifier);
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
                    onPressed: () {
                      prograseNofier.addPackageToPubspec(directory: directory);
                    },
                    child: const Text('Add Google map to project'),
                  ),
                  const SizedBox(height: 16),
                  Text(prograse),
                ],
              )
          ],
        ),
      ),
    );
  }
}
