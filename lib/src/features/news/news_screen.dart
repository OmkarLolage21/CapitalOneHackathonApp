import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Newsfeed')),
      body: ListView(padding: const EdgeInsets.all(16), children: const [
        Card(child: ListTile(title: Text('IMD Bulletin – 13 Aug 2025'))),
        Card(child: ListTile(title: Text('Agri policy: New DBT guidelines'))),
      ]),
    );
  }
}
