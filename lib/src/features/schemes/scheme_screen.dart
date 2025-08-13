import 'package:flutter/material.dart';

class SchemesScreen extends StatelessWidget {
  const SchemesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schemes & Finance')),
      body: ListView(padding: const EdgeInsets.all(16), children: const [
        Card(child: ListTile(title: Text('PM-Kisan'), subtitle: Text('Eligible based on landholding < 2 ha. Tap to know documents.'))),
        Card(child: ListTile(title: Text('Kisan Credit Card (KCC)'), subtitle: Text('Get short-term credit at subsidized rate'))),
      ]),
    );
  }
}