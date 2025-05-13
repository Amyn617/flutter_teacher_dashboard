import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_dashboard/services/attendance_service.dart';
import 'package:teacher_dashboard/widgets/class_card.dart';
import 'package:intl/intl.dart';
import 'package:teacher_dashboard/widgets/sticky_app_bar.dart';
import 'package:teacher_dashboard/widgets/summary_card.dart';
import 'package:teacher_dashboard/widgets/calendar_card.dart';
import 'package:teacher_dashboard/widgets/upcoming_class.dart';
import 'package:teacher_dashboard/theme/app_theme.dart';
import 'package:animate_do/animate_do.dart';
import 'package:teacher_dashboard/pages/class_detail_page.dart';
import 'package:teacher_dashboard/pages/add_class_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
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
      body: CustomScrollView(
        slivers: [
          StickyAppBar(
            title: 'Welcome Back!',
            subtitle: today,
            expandedHeight: 120.0,
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
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Summary Section
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  child: Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'Total Classes',
                          value: classes.length.toString(),
                          icon: Icons.school_outlined,
                          color: isDarkMode
                              ? AppTheme.darkAccentColor
                              : AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SummaryCard(
                          title: 'Avg. Attendance',
                          value: '${averageAttendance.toStringAsFixed(1)}%',
                          icon: Icons.bar_chart_outlined,
                          color: isDarkMode
                              ? AppTheme.darkAccentColor
                              : AppTheme.accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                FadeInUp(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 200),
                  child: Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: 'Total Students',
                          value: totalStudents.toString(),
                          icon: Icons.people_outline,
                          color: isDarkMode
                              ? AppTheme.darkAccentColor
                              : AppTheme.secondaryColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SummaryCard(
                          title: 'Classes Today',
                          value: classesToday.toString(),
                          icon: Icons.today_outlined,
                          color: isDarkMode
                              ? AppTheme.darkAccentColor
                              : AppTheme.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Calendar Card section
                FadeIn(
                  duration: const Duration(milliseconds: 800),
                  child: const CalendarCard(),
                ),
                const SizedBox(height: 24),

                // Today's Classes section
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Classes",
                        style: theme.textTheme.titleLarge,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? AppTheme.darkAccentColor.withAlpha(40)
                              : AppTheme.primaryColor.withAlpha(25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$classesToday Classes',
                          style: TextStyle(
                            color: isDarkMode
                                ? AppTheme.darkAccentColor
                                : AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Today's classes list
                ...classes
                    .where((cls) => cls.days.contains(currentDay))
                    .map(
                      (cls) => FadeInLeft(
                        from: 20,
                        duration: const Duration(milliseconds: 400),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: UpcomingClass(
                            classModel: cls,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ClassDetailPage(classModel: cls),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    )
                    .toList(),

                const SizedBox(height: 24),

                // All Classes section
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text('All Classes', style: theme.textTheme.titleLarge),
                ),

                // All classes list
                ...classes.map(
                  (cls) => FadeInUp(
                    from: 20,
                    duration: const Duration(milliseconds: 400),
                    child: ClassCard(
                      classModel: cls,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ClassDetailPage(classModel: cls),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Bottom padding for FAB
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withAlpha(60),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () {
            // Navigate to add class page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddClassPage(),
              ),
            );
          },
          label: Text(
            'Add Class',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
