import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/common.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('👋 Namaste, Kisan!')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.2, mainAxisSpacing: 12, crossAxisSpacing: 12),
            children: [
              _QuickTile(label: "Ask a Question", icon: Icons.chat_bubble_rounded, onTap: () => context.go('/chat')),
              _QuickTile(label: "Market Prices", icon: Icons.currency_rupee, onTap: () => context.go('/market')),
              _QuickTile(label: "Today’s Weather", icon: Icons.cloud, onTap: () => context.go('/weather')),
              _QuickTile(label: "Schemes & Loans", icon: Icons.account_balance, onTap: () => context.go('/schemes')),
            ],
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: 'Today’s Advisories',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('• No irrigation needed today.'),
                Text('• High pest risk: monitor for aphids on cotton.'),
              ],
            ),
          ),
          SectionCard(
            title: 'Newsfeed',
            onTap: () => context.go('/news'),
            child: Column(
              children: const [
                ListTile(title: Text('IMD warns of heatwave in Vidarbha'), subtitle: Text('Tap to see details')), 
                ListTile(title: Text('MSP update & procurement windows')), 
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/chat'),
        label: const Text('Chat'),
        icon: const Icon(Icons.mic),
      ),
    );
  }
}

class _QuickTile extends StatelessWidget {
  final String label; final IconData icon; final VoidCallback onTap;
  const _QuickTile({required this.label, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(icon, size: 32), const SizedBox(height: 8), Text(label, textAlign: TextAlign.center)],
          ),
        ),
      ),
    );
  }
}