import 'package:flutter/material.dart';

/// Top status bar: menu icon, notification bell, search, and a
/// verified-profile chip on the right.
class FeedTopBar extends StatelessWidget {
  const FeedTopBar({
    super.key,
    required this.userName,
    required this.avatarUrl,
    this.onMenuTap,
    this.onNotificationsTap,
    this.onSearchTap,
    this.onProfileTap,
  });

  final String userName;
  final String avatarUrl;
  final VoidCallback? onMenuTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _CircleIconButton(icon: Icons.grid_view_rounded, onTap: onMenuTap),
          const Spacer(),
          _CircleIconButton(
            icon: Icons.notifications_none_rounded,
            onTap: onNotificationsTap,
          ),
          const SizedBox(width: 10),
          _CircleIconButton(icon: Icons.search_rounded, onTap: onSearchTap),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              padding: const EdgeInsets.only(left: 4, right: 10, top: 4, bottom: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(radius: 14, backgroundImage: NetworkImage(avatarUrl)),
                  const SizedBox(width: 6),
                  Text(
                    userName,
                    style: theme.textTheme.labelMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.verified, size: 14, color: Colors.blue),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 20, color: theme.colorScheme.onSurface),
        ),
      ),
    );
  }
}
