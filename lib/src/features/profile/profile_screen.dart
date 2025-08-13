import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: ListView(padding: const EdgeInsets.all(16), children: const [
        ListTile(title: Text('Name'), subtitle: Text('Omkar')), // bind with state
        ListTile(title: Text('Language'), subtitle: Text('Marathi')), 
        ListTile(title: Text('Crops'), subtitle: Text('Cotton, Soybean')),
        SwitchListTile(value: true, onChanged: null, title: Text('Weather Alerts')),
      ]),
    );
  }
}
