import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heyflutter/providers/directory_provider.dart';

import '../constants/constants.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final directory = ref.watch(directoryProvider);
    final directoryNotifier = ref.read(directoryProvider.notifier);
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
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
