import 'package:flutter/material.dart';
import '../theme/spacing.dart';

class BrandHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  const BrandHeader({super.key, required this.title, this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(Gaps.md, Gaps.md, Gaps.md, 0),
      padding: const EdgeInsets.all(Gaps.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Radii.lg),
        gradient: LinearGradient(
          colors: [scheme.primaryContainer, scheme.primary.withOpacity(0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: scheme.primary.withOpacity(0.15), blurRadius: 24, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.agriculture, color: scheme.onPrimaryContainer, size: 36),
          const SizedBox(width: Gaps.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: scheme.onPrimaryContainer,
                          fontSize: 24,
                          height: 1.1,
                        )),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.onPrimaryContainer.withOpacity(0.9),
                        ),
                  )
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}