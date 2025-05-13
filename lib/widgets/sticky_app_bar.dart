import 'package:flutter/material.dart';
import 'package:teacher_dashboard/theme/app_theme.dart';

class StickyAppBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget>? actions;
  final bool isPinned;
  final Widget? leading;
  final Widget? flexibleSpace;
  final double expandedHeight;

  const StickyAppBar({
    super.key,
    required this.title,
    this.subtitle = "",
    this.actions,
    this.isPinned = true,
    this.leading,
    this.flexibleSpace,
    this.expandedHeight = 120.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return SliverAppBar(
      pinned: isPinned,
      floating: true,
      expandedHeight: expandedHeight,
      elevation: 0,
      scrolledUnderElevation: 5,
      shadowColor: isDarkMode
          ? Colors.black.withAlpha(80)
          : AppTheme.primaryColor.withAlpha(30),
      backgroundColor:
          isDarkMode ? const Color(0xFF1F1F1F) : AppTheme.primaryColor,
      leading: leading,
      actions: actions ?? [],
      flexibleSpace: flexibleSpace ??
          FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                    shadows: [
                      Shadow(
                        color: Colors.black.withAlpha(51), // ~0.2 opacity
                        offset: const Offset(0, 1),
                        blurRadius: 2,
                      )
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withAlpha(230),
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryColor,
                    isDarkMode
                        ? const Color(
                            0xFF303F9F) // Darker version for dark mode
                        : const Color(0xFF4668D9), // Original lighter shade
                  ],
                  stops: const [0.2, 0.9],
                ),
              ),
            ),
          ),
    );
  }
}
