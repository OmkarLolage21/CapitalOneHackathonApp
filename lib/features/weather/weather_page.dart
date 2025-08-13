import 'package:flutter/material.dart';
import '../../theme/spacing.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Weather')),
      body: ListView(
        padding: const EdgeInsets.all(Gaps.md),
        children: [
          Card(
            child: Padding(
              padding: kCardPadding,
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.wb_sunny, color: scheme.primary, size: 48),
                      const SizedBox(width: Gaps.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Today', style: Theme.of(context).textTheme.titleLarge),
                            Text('Sunny, 28°C', style: Theme.of(context).textTheme.headlineSmall),
                            const Text('Perfect conditions for farming'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Simple weather snippet for dashboard
class WeatherSnippet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: kCardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.wb_sunny, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: Gaps.sm),
                Text('Weather Today', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: Gaps.sm),
            const Text('Sunny, 28°C\nPerfect for field work'),
          ],
        ),
      ),
    );
  }
}