import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_dashboard/theme/app_theme.dart';
import 'package:teacher_dashboard/widgets/sticky_app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotificationsEnabled = true;
  bool _emailNotificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          StickyAppBar(
            title: 'Settings',
            subtitle: 'Manage your preferences',
            actions: [
              IconButton(
                icon: const CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/avatar_placeholder.png',
                  ),
                  radius: 18,
                ),
                onPressed: () {
                  // Optional: Navigate to a detailed profile page or action
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionTitle(context, 'Profile'),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        context,
                        'Name',
                        'Dr. Eleanor Vance',
                        Icons.person_outline,
                      ),
                      _buildSettingsTile(
                        context,
                        'Email',
                        'eleanor.vance@example.com',
                        Icons.email_outlined,
                      ),
                      _buildSettingsTile(
                        context,
                        'School',
                        'Springfield High',
                        Icons.school_outlined,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Notifications'),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: Text(
                          'Push Notifications',
                          style: theme.textTheme.bodyLarge,
                        ),
                        value: _pushNotificationsEnabled,
                        onChanged: (bool value) {
                          setState(() {
                            _pushNotificationsEnabled = value;
                          });
                        },
                        secondary: Icon(
                          Icons.notifications_active_outlined,
                          color: isDarkMode
                              ? AppTheme.darkAccentColor
                              : AppTheme.primaryColor,
                        ),
                        activeColor: isDarkMode
                            ? AppTheme.darkAccentColor
                            : AppTheme.accentColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      SwitchListTile(
                        title: Text(
                          'Email Notifications',
                          style: theme.textTheme.bodyLarge,
                        ),
                        value: _emailNotificationsEnabled,
                        onChanged: (bool value) {
                          setState(() {
                            _emailNotificationsEnabled = value;
                          });
                        },
                        secondary: Icon(
                          Icons.mail_outline,
                          color: isDarkMode
                              ? AppTheme.darkAccentColor
                              : AppTheme.primaryColor,
                        ),
                        activeColor: isDarkMode
                            ? AppTheme.darkAccentColor
                            : AppTheme.accentColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Appearance'),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title:
                            Text('Dark Mode', style: theme.textTheme.bodyLarge),
                        value: themeNotifier.isDarkMode(),
                        onChanged: (bool value) {
                          themeNotifier.toggleTheme();
                        },
                        secondary: Icon(
                          Icons.brightness_6_outlined,
                          color: isDarkMode
                              ? AppTheme.darkAccentColor
                              : AppTheme.primaryColor,
                        ),
                        activeColor: isDarkMode
                            ? AppTheme.darkAccentColor
                            : AppTheme.accentColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Account'),
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        context,
                        'Edit Profile',
                        'Update your personal information',
                        Icons.person_outline,
                      ),
                      _buildSettingsTile(
                        context,
                        'Change Password',
                        'Update your account security',
                        Icons.lock_outline,
                      ),
                      _buildSettingsTile(
                        context,
                        'Logout',
                        'Sign out of your account',
                        Icons.logout_outlined,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.logout_outlined),
                    label: const Text('Logout'),
                    onPressed: () {
                      // Implement logout functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Logout functionality not implemented yet.'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.error.withAlpha(200),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      textStyle: theme.textTheme.labelLarge,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
      child: Text(
        title,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: isDarkMode ? AppTheme.darkAccentColor : AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return ListTile(
      leading: Icon(icon,
          color: isDarkMode
              ? AppTheme.darkAccentColor.withAlpha(200)
              : theme.colorScheme.primary.withAlpha(200)),
      title: Text(title, style: theme.textTheme.bodyLarge),
      subtitle: Text(subtitle, style: theme.textTheme.bodyMedium),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
