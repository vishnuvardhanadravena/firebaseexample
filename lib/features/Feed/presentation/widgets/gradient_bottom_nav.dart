import 'package:flutter/material.dart';

class GradientBottomNav extends StatelessWidget {
  const GradientBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onCreateTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onCreateTap;

  static const _items = [
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.explore_outlined, label: 'Discover'),
    (icon: Icons.mail_outline_rounded, label: 'Inbox'),
    (icon: Icons.person_outline_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 84,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            left: 16,
            right: 16,
            top: 22,
            child: Container(
              height: 62,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < _items.length; i++) ...[
                    if (i == 2) const SizedBox(width: 48), // gap for FAB
                    _NavItem(
                      icon: _items[i].icon,
                      label: _items[i].label,
                      selected: currentIndex == i,
                      onTap: () => onTap(i),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Material(
              color: theme.colorScheme.primary,
              shape: const CircleBorder(),
              elevation: 4,
              child: InkWell(
                onTap: onCreateTap,
                customBorder: const CircleBorder(),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Icon(Icons.add, color: Colors.white, size: 26),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = selected ? theme.colorScheme.primary : theme.colorScheme.outline;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
