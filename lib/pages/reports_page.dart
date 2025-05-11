import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_dashboard/services/attendance_service.dart';
// import 'package:teacher_dashboard/models/class_model.dart'; // Removed unused import
import 'package:teacher_dashboard/widgets/attendance_chart.dart';
import 'package:teacher_dashboard/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:teacher_dashboard/theme/app_theme.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, MMM d').format(DateTime.now());
    final attendanceService = Provider.of<AttendanceService>(context);
    final classes = attendanceService.classes;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Attendance Reports',
        subtitle: today,
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundImage: AssetImage(
                'assets/images/avatar_placeholder.png',
              ),
              radius: 18,
            ),
            onPressed: () {
              // Profile action
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: classes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bar_chart_outlined,
                    size: 60,
                    color: AppTheme.textSecondary.withAlpha(100),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No classes available to generate reports.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: classes.length,
              itemBuilder: (context, index) {
                final classModel = classes[index];
                final weeklyStats =
                    attendanceService.getWeeklyAttendanceStats(classModel.id);

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          classModel.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          classModel.subject,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (weeklyStats.values.every((val) => val == 0.0))
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 32.0,
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: AppTheme.textSecondary.withAlpha(
                                      150,
                                    ),
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'No attendance data recorded for this class yet.',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          AttendanceChart(weeklyData: weeklyStats),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
