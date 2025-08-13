import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/l10n.dart';
import '../../theme/spacing.dart';
import '../../widgets/brand_header.dart';
import 'widgets/quick_actions.dart';
import '../weather/weather_page.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: BrandHeader(
              title: l.greeting('Farmer'),
              subtitle: 'Here's what matters today in your farm.',
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined),
                color: scheme.onPrimaryContainer,
                tooltip: 'Alerts',
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: Gaps.md)),
          const SliverToBoxAdapter(child: QuickActions()),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: Gaps.md, vertical: Gaps.sm),
            sliver: SliverToBoxAdapter(child: _AdvisoriesCard()),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: Gaps.md, vertical: Gaps.sm),
            sliver: SliverToBoxAdapter(child: WeatherSnippet()),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: Gaps.xl)),
        ],
      ),
    );
  }
}

class _AdvisoriesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: kCardPadding,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Icon(Icons.tips_and_updates_outlined, color: scheme.primary),
              const SizedBox(width: Gaps.sm),
              Text(l.advisoriesToday, style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              TextButton.icon(onPressed: () {}, icon: const Icon(Icons.info_outline), label: Text(l.why)),
            ],
          ),
          const SizedBox(height: Gaps.sm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _AdvisoryPill(icon: Icons.water_drop, label: 'No irrigation needed today', color: Color(0xFF0EA5E9)),
              _AdvisoryPill(icon: Icons.bug_report_outlined, label: 'Pest risk is high', color: Color(0xFFEF4444)),
              _AdvisoryPill(icon: Icons.thermostat, label: 'Temp stable next 3 days', color: Color(0xFFF59E0B)),
            ],
          ),
        ]),
      ),
    );
  }
}

class _AdvisoryPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _AdvisoryPill({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: scheme.onSurface)),
      ]),
    );
  }
}

// Placeholder for weather snippet - will be replaced when weather_page.dart is created
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