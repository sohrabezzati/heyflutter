import 'package:flutter/material.dart';

class MobileHomeScreen extends StatelessWidget {
  const MobileHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HeyFlutter'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),

        // add map view here
      ),
    );
  }
}
