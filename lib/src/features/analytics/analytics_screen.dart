import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: ListView(padding: const EdgeInsets.all(16), children: const [
        Card(child: ListTile(title: Text('Active Farmers'), subtitle: Text('1,284 this week'))),
        Card(child: ListTile(title: Text('Pest Alerts Sent'), subtitle: Text('3,112 in last 24h'))),
        Card(child: ListTile(title: Text('Water Saved (est.)'), subtitle: Text('1.2M liters'))),
      ]),
    );
  }
}