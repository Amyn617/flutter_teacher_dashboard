import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_dashboard/models/class_model.dart';
import 'package:teacher_dashboard/services/attendance_service.dart';
import 'package:teacher_dashboard/widgets/sticky_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:teacher_dashboard/widgets/upcoming_class.dart';
import 'package:teacher_dashboard/theme/app_theme.dart';
import 'package:animate_do/animate_do.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<ClassModel>> _events = {};
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    // Delay fetching events until after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEvents();
    });
  }

  void _loadEvents() {
    final attendanceService = Provider.of<AttendanceService>(
      context,
      listen: false,
    );
    final classes = attendanceService.classes;
    final Map<DateTime, List<ClassModel>> eventSource = {};

    for (var classModel in classes) {
      for (var dayName in classModel.days) {
        // This is a simplified way to map day names to dates for the current month and nearby months
        for (int i = -30; i <= 30; i++) {
          // Check for classes in a 60-day window
          final date = DateTime.now().add(Duration(days: i));
          if (DateFormat('EEEE').format(date) == dayName) {
            final dayOnly = DateTime(date.year, date.month, date.day);
            if (eventSource[dayOnly] == null) eventSource[dayOnly] = [];
            // Avoid adding duplicate class instances
            if (!eventSource[dayOnly]!.any(
              (element) => element.id == classModel.id,
            )) {
              eventSource[dayOnly]!.add(classModel);
            }
          }
        }
      }
    }
    if (mounted) {
      setState(() {
        _events = eventSource;
      });
    }
  }

  List<ClassModel> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final todayString = DateFormat('EEEE, MMM d').format(DateTime.now());
    final selectedDayClasses = _getEventsForDay(_selectedDay ?? _focusedDay);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          StickyAppBar(
            title: 'Class Schedule',
            subtitle: todayString,
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
            child: FadeIn(
              duration: const Duration(milliseconds: 600),
              child: Card(
                margin: const EdgeInsets.all(16.0),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2022, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    eventLoader: _getEventsForDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: theme.colorScheme.primary.withAlpha(150),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      markersMaxCount: 3,
                      markersAnchor: 0.7,
                      markerDecoration: BoxDecoration(
                        color: theme.colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      weekendTextStyle: theme.textTheme.bodyMedium!,
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonTextStyle: TextStyle(
                        color: isDarkMode
                            ? AppTheme.darkAccentColor
                            : AppTheme.primaryColor,
                        fontSize: 14.0,
                      ),
                      formatButtonDecoration: BoxDecoration(
                        color: isDarkMode
                            ? AppTheme.darkAccentColor.withAlpha(40)
                            : AppTheme.primaryColor.withAlpha(40),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      titleTextStyle: theme.textTheme.titleMedium!,
                      titleCentered: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDay == null
                        ? 'Today\'s Classes'
                        : DateFormat('MMM d, yyyy').format(_selectedDay!),
                    style: theme.textTheme.titleLarge,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppTheme.darkAccentColor.withAlpha(40)
                          : AppTheme.primaryColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${selectedDayClasses.length} Classes',
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
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final classModel = selectedDayClasses[index];
                return FadeInLeft(
                  from: 20,
                  delay: Duration(milliseconds: 100 * index),
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4.0),
                    child: UpcomingClass(
                      classModel: classModel,
                      onTap: () {
                        // Navigate to class detail page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar: AppBar(
                                title: Text(classModel.name),
                              ),
                              body: const Center(
                                child: Text(
                                    'Class detail page will be implemented'),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              childCount: selectedDayClasses.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 80), // Bottom padding for FAB
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add new class functionality
        },
        label: const Text('Add Class'),
        icon: const Icon(Icons.add),
        backgroundColor: theme.colorScheme.primary,
      ),
    );
  }
}
