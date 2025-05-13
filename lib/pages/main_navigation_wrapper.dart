import 'package:flutter/material.dart';
import 'package:teacher_dashboard/pages/dashboard_page.dart';
import 'package:teacher_dashboard/pages/reports_page_new.dart';
import 'package:teacher_dashboard/pages/schedule_page.dart';
import 'package:teacher_dashboard/pages/settings_page.dart';
import 'package:teacher_dashboard/theme/app_theme.dart';

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const DashboardPage(),
    const SchedulePage(),
    const ReportsPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        // Use IndexedStack to preserve state of pages
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 16,
              offset: const Offset(0, -2),
              spreadRadius: 0,
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: NavigationBar(
          height: 70,
          surfaceTintColor: Colors.transparent,
          backgroundColor: theme.scaffoldBackgroundColor,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: <Widget>[
            NavigationDestination(
              icon: Icon(
                Icons.dashboard_outlined,
                color: isDarkMode ? Colors.white70 : AppTheme.textSecondary,
              ),
              selectedIcon: Icon(
                Icons.dashboard,
                color: AppTheme.primaryColor,
              ),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.calendar_today_outlined,
                color: isDarkMode ? Colors.white70 : AppTheme.textSecondary,
              ),
              selectedIcon: Icon(
                Icons.calendar_today,
                color: AppTheme.primaryColor,
              ),
              label: 'Schedule',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.bar_chart_outlined,
                color: isDarkMode ? Colors.white70 : AppTheme.textSecondary,
              ),
              selectedIcon: Icon(
                Icons.bar_chart,
                color: AppTheme.primaryColor,
              ),
              label: 'Reports',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.settings_outlined,
                color: isDarkMode ? Colors.white70 : AppTheme.textSecondary,
              ),
              selectedIcon: Icon(
                Icons.settings,
                color: AppTheme.primaryColor,
              ),
              label: 'Settings',
            ),
          ],
          indicatorColor: AppTheme.primaryColor.withAlpha(30),
        ),
      ),
    );
  }
}
