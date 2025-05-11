import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_dashboard/services/attendance_service.dart';
import 'package:teacher_dashboard/widgets/class_card.dart';
import 'package:intl/intl.dart';
import 'package:teacher_dashboard/widgets/custom_app_bar.dart';
import 'package:teacher_dashboard/widgets/summary_card.dart';
import 'package:teacher_dashboard/widgets/calendar_card.dart';
import 'package:teacher_dashboard/widgets/upcoming_class.dart';
import 'package:teacher_dashboard/theme/app_theme.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final attendanceService = Provider.of<AttendanceService>(context);
    final classes = attendanceService.classes;
    final today = DateFormat('EEEE, MMM d').format(DateTime.now());

    // Calculate summary data
    int totalStudents = 0;
    double totalAttendanceRate = 0;
    int classesToday = 0;
    final String currentDay = DateFormat('EEEE').format(DateTime.now());

    for (var classModel in classes) {
      totalStudents += classModel.totalStudents;
      final records = attendanceService.getAttendanceForClass(classModel.id);
      if (records.isNotEmpty) {
        totalAttendanceRate +=
            records.fold<double>(0, (prev, rec) => prev + rec.attendanceRate) /
            records.length;
      }
      if (classModel.days.contains(currentDay)) {
        classesToday++;
      }
    }
    final averageAttendance =
        classes.isNotEmpty ? totalAttendanceRate / classes.length : 0.0;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Welcome Back!', // Or a personalized greeting
        subtitle: today,
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://randomuser.me/api/portraits/women/44.jpg', // Placeholder
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Summary Section
          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'Total Classes',
                  value: classes.length.toString(),
                  icon: Icons.school_outlined,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SummaryCard(
                  title: 'Avg. Attendance',
                  value: '${averageAttendance.toStringAsFixed(1)}%',
                  icon: Icons.bar_chart_outlined,
                  color: AppTheme.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'Total Students',
                  value: totalStudents.toString(),
                  icon: Icons.people_outline,
                  color: AppTheme.secondaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SummaryCard(
                  title: 'Classes Today',
                  value: classesToday.toString(),
                  icon: Icons.today_outlined,
                  color: AppTheme.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Calendar Section
          const CalendarCard(),
          const SizedBox(height: 24),

          // Upcoming Classes Section
          Text(
            'Today\'s Schedule',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (classes
              .where((c) => c.days.contains(currentDay))
              .toList()
              .isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.event_busy_outlined,
                      size: 48,
                      color: AppTheme.textSecondary.withAlpha(128),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No classes scheduled for today.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  classes
                      .where((c) => c.days.contains(currentDay))
                      .toList()
                      .length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final todayClasses =
                    classes.where((c) => c.days.contains(currentDay)).toList();
                final classModel = todayClasses[index];
                return UpcomingClass(
                  classModel: classModel,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/class-detail',
                      arguments: classModel,
                    );
                  },
                );
              },
            ),

          const SizedBox(height: 24),

          // All Classes Section (Optional, could be a separate tab or page)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'All Your Classes',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to a page with all classes if needed
                },
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount:
                classes.length > 3
                    ? 3
                    : classes.length, // Show a few or a link to all
            itemBuilder: (context, index) {
              // Potentially use a different card or a more compact version here
              return ClassCard(
                classModel: classes[index],
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/class-detail',
                    arguments: classes[index],
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add new class
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Class'),
        backgroundColor: AppTheme.accentColor,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            0, // This should be managed by a state variable if navigation is implemented
        onTap: (index) {
          // Handle bottom navigation tap
        },
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondary,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed, // Ensures all items are visible
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
