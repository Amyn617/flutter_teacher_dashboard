import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_dashboard/pages/main_navigation_wrapper.dart';
import 'package:teacher_dashboard/services/attendance_service.dart';
import 'package:teacher_dashboard/theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ThemeNotifier(AppTheme.lightTheme)),
        ChangeNotifierProvider(create: (_) => AttendanceService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'Teacher Dashboard',
      theme: themeNotifier.getTheme(),
      home: const MainNavigationWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}
