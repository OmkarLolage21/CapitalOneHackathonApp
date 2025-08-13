import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/spacing.dart';
import '../../../l10n/l10n.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final items = [
      _Item(icon: Icons.question_answer_outlined, label: l.quickAsk, route: '/chat', color: const Color(0xFF14B8A6)),
      _Item(icon: Icons.currency_rupee_outlined, label: l.marketPrices, route: '/market', color: const Color(0xFFF59E0B)),
      _Item(icon: Icons.wb_sunny_outlined, label: l.todayWeather, route: '/weather', color: const Color(0xFF0EA5E9)),
      _Item(icon: Icons.account_balance_outlined, label: l.schemesLoans, route: '/schemes', color: const Color(0xFF84CC16)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Gaps.md),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.25,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (_, i) => _QuickActionCard(item: items[i]).animate().fadeIn(delay: (100 * i).ms, duration: 250.ms).slideY(begin: 0.08),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final _Item item;
  const _QuickActionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => context.go(item.route),
      borderRadius: BorderRadius.circular(Radii.md),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Radii.md),
          gradient: LinearGradient(
            colors: [item.color.withOpacity(0.16), scheme.surface],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: item.color.withOpacity(0.25)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Gaps.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: item.color,
                foregroundColor: Colors.white,
                radius: 22,
                child: Icon(item.icon),
              ),
              const Spacer(),
              Text(item.label, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _Item {
  final IconData icon;
  final String label;
  final String route;
  final Color color;
  _Item({required this.icon, required this.label, required this.route, required this.color});
}