import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Advisory Library')),
      body: ListView(padding: const EdgeInsets.all(16), children: const [
        Card(child: ListTile(title: Text('Cotton Nutrient Guide'), subtitle: Text('Downloadable pictorial guide'))),
        Card(child: ListTile(title: Text('Rice Pest Management'))),
      ]),
    );
  }
}