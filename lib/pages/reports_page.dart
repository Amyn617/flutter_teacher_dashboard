import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_dashboard/services/attendance_service.dart';
import 'package:teacher_dashboard/widgets/attendance_chart.dart';
import 'package:teacher_dashboard/widgets/custom_app_bar.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool _showElevation = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      _showElevation = _scrollController.offset > 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, MMM d').format(DateTime.now());
    final attendanceService = Provider.of<AttendanceService>(context);
    final classes = attendanceService.classes;
    final theme = Theme.of(context);

    if (classes.isEmpty) {
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
        body: Center(
          child: FadeIn(
            duration: const Duration(milliseconds: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bar_chart_outlined,
                  size: 60,
                  color: AppTheme.textSecondary.withAlpha(100),
                ),
                const SizedBox(height: 16),
                Text(
                  'No classes available to generate reports.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                expandedHeight: 110.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: CustomAppBar(
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
                ),
                backgroundColor: Colors.transparent,
                elevation: _showElevation ? 4 : 0,
                bottom: TabBar(
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(text: 'All Classes'),
                    Tab(text: 'Weekly'),
                    Tab(text: 'Monthly'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // All Classes Tab
            Builder(
              builder: (BuildContext context) {
                return CustomScrollView(
                  slivers: [
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: classes.length,
                            itemBuilder: (context, index) {
                              final classModel = classes[index];
                              final weeklyStats = attendanceService
                                  .getWeeklyAttendanceStats(classModel.id);

                              return FadeInUp(
                                duration:
                                    Duration(milliseconds: 300 + (index * 100)),
                                child: Card(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          classModel.name,
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          classModel.subject,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: AppTheme.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        if (weeklyStats.values
                                            .every((val) => val == 0.0))
                                          Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 32.0,
                                              ),
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.info_outline,
                                                    color: AppTheme
                                                        .textSecondary
                                                        .withAlpha(
                                                      150,
                                                    ),
                                                    size: 32,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    'No attendance data recorded for this class yet.',
                                                    style: theme
                                                        .textTheme.bodyMedium
                                                        ?.copyWith(
                                                      color: AppTheme
                                                          .textSecondary,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        else
                                          AttendanceChart(
                                              weeklyData: weeklyStats),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ]),
                    ),
                  ],
                );
              },
            ),
            // Weekly Tab (placeholder)
            Center(
                child: Text('Weekly reports coming soon',
                    style: theme.textTheme.titleMedium)),
            // Monthly Tab (placeholder)
            Center(
                child: Text('Monthly reports coming soon',
                    style: theme.textTheme.titleMedium)),
          ],
        ),
      ),
    );
  }
}
