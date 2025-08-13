import 'package:flutter/material.dart';

class PestScreen extends StatelessWidget {
  const PestScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pest & Disease Alerts')),
      body: ListView(padding: const EdgeInsets.all(16), children: const [
        Card(child: ListTile(title: Text('Aphid risk: High'), subtitle: Text('Scout now. Use yellow sticky traps.'))),
        Card(child: ListTile(title: Text('Fall armyworm: Moderate'), subtitle: Text('Check whorl stage, pheromone traps.'))),
      ]),
    );
  }
}