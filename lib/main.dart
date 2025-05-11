import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_dashboard/models/class_model.dart';
import 'package:teacher_dashboard/pages/dashboard_page.dart';
import 'package:teacher_dashboard/pages/class_detail_page.dart';
import 'package:teacher_dashboard/services/attendance_service.dart';
import 'package:teacher_dashboard/theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AttendanceService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teacher Attendance Dashboard',
      theme: AppTheme.getTheme(),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) => const DashboardPage());
        } else if (settings.name == '/class-detail') {
          final classModel = settings.arguments as ClassModel;
          return MaterialPageRoute(
            builder: (context) => ClassDetailPage(classModel: classModel),
          );
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
