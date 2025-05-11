import 'package:flutter/material.dart';
import 'package:teacher_dashboard/pages/dashboard_page.dart';
import 'package:teacher_dashboard/pages/reports_page.dart';
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
    return Scaffold(
      body: IndexedStack(
        // Use IndexedStack to preserve state of pages
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10), // Replaced withOpacity(0.04)
              blurRadius: 16,
              offset: const Offset(0, -2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              backgroundColor: Colors.transparent,
              elevation: 0,
              height: 65,
              surfaceTintColor: Colors.transparent,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: <NavigationDestination>[
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined,
                      size: 24, color: AppTheme.textSecondary),
                  selectedIcon: Icon(Icons.dashboard,
                      size: 24, color: AppTheme.primaryColor),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.calendar_today_outlined,
                      size: 24, color: AppTheme.textSecondary),
                  selectedIcon: Icon(Icons.calendar_today,
                      size: 24, color: AppTheme.primaryColor),
                  label: 'Schedule',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bar_chart_outlined,
                      size: 24, color: AppTheme.textSecondary),
                  selectedIcon: Icon(Icons.bar_chart,
                      size: 24, color: AppTheme.primaryColor),
                  label: 'Reports',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined,
                      size: 24, color: AppTheme.textSecondary),
                  selectedIcon: Icon(Icons.settings,
                      size: 24, color: AppTheme.primaryColor),
                  label: 'Settings',
                ),
              ],
              indicatorColor:
                  AppTheme.primaryColor.withAlpha(38), // ~0.15 opacity
            ),
          ),
        ),
      ),
    );
  }
}
