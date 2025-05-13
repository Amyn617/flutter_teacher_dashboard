import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_dashboard/services/attendance_service.dart';
import 'package:teacher_dashboard/widgets/attendance_chart.dart';
import 'package:teacher_dashboard/widgets/sticky_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:teacher_dashboard/theme/app_theme.dart';
import 'package:animate_do/animate_do.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, MMM d').format(DateTime.now());
    final attendanceService = Provider.of<AttendanceService>(context);
    final classes = attendanceService.classes;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (classes.isEmpty) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            StickyAppBar(
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
              ],
            ),
            SliverFillRemaining(
              child: Center(
                child: FadeIn(
                  duration: const Duration(milliseconds: 600),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bar_chart_outlined,
                        size: 60,
                        color: isDarkMode
                            ? Colors.white.withAlpha(100)
                            : AppTheme.textSecondary.withAlpha(100),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No classes available to generate reports.',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode
                              ? Colors.white.withAlpha(200)
                              : AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Generate weekly attendance data
    Map<String, double> weeklyAttendanceData = {};
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // Initialize with zeros
    for (var day in days) {
      weeklyAttendanceData[day] = 0.0;
    }

    // Fill with actual data
    for (var classModel in classes) {
      final records = attendanceService.getAttendanceForClass(classModel.id);
      for (var record in records) {
        final day = DateFormat('E').format(record.date).substring(0, 3);
        if (weeklyAttendanceData.containsKey(day)) {
          // Add to existing day and average later
          weeklyAttendanceData[day] =
              weeklyAttendanceData[day]! + record.attendanceRate;
        }
      }
    }

    // Calculate averages
    for (var day in days) {
      if (weeklyAttendanceData[day]! > 0) {
        // Assuming each day with data has the same number of classes
        weeklyAttendanceData[day] = weeklyAttendanceData[day]! / classes.length;
      }
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          StickyAppBar(
            title: 'Attendance Reports',
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
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Text(
                    'Performance Overview',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                FadeIn(
                  duration: const Duration(milliseconds: 800),
                  child: AttendanceChart(weeklyData: weeklyAttendanceData),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Material(
                    color: Colors.transparent,
                    child: TabBar(
                      controller: _tabController,
                      labelColor: isDarkMode
                          ? AppTheme.darkAccentColor
                          : AppTheme.primaryColor,
                      unselectedLabelColor: isDarkMode
                          ? Colors.white.withAlpha(150)
                          : AppTheme.textSecondary,
                      indicatorColor: isDarkMode
                          ? AppTheme.darkAccentColor
                          : AppTheme.primaryColor,
                      tabs: const [
                        Tab(text: 'By Class'),
                        Tab(text: 'By Student'),
                        Tab(text: 'By Month'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildClassReports(context, classes, attendanceService),
                _buildStudentReports(context),
                _buildMonthlyReports(context),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Export or share reports
        },
        label: const Text('Export Reports'),
        icon: const Icon(Icons.share),
        backgroundColor: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildClassReports(
      BuildContext context, List<dynamic> classes, AttendanceService service) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          final classModel = classes[index];
          final records = service.getAttendanceForClass(classModel.id);
          double avgAttendance = 0.0;

          if (records.isNotEmpty) {
            avgAttendance = records.fold<double>(
                  0,
                  (prev, record) => prev + record.attendanceRate,
                ) /
                records.length;
          }

          return FadeInUp(
            delay: Duration(milliseconds: 100 * index),
            duration: const Duration(milliseconds: 400),
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  classModel.name,
                  style: theme.textTheme.titleMedium,
                ),
                subtitle: Text(
                  classModel.subject,
                  style: theme.textTheme.bodyMedium,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getAttendanceColor(avgAttendance, isDarkMode)
                            .withAlpha(40),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${avgAttendance.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: _getAttendanceColor(avgAttendance, isDarkMode),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: isDarkMode
                          ? Colors.white.withAlpha(150)
                          : AppTheme.textSecondary,
                    ),
                  ],
                ),
                onTap: () {
                  // Navigate to detailed class report
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStudentReports(BuildContext context) {
    return Center(
      child: Text(
        'Student reports will be implemented',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildMonthlyReports(BuildContext context) {
    return Center(
      child: Text(
        'Monthly reports will be implemented',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Color _getAttendanceColor(double rate, bool isDarkMode) {
    if (rate >= 80) {
      return isDarkMode ? Colors.greenAccent : Colors.green;
    } else if (rate >= 60) {
      return isDarkMode ? Colors.orangeAccent : Colors.orange;
    } else {
      return isDarkMode ? Colors.redAccent : Colors.red;
    }
  }
}
