import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_dashboard/models/class_model.dart';
import 'package:teacher_dashboard/services/attendance_service.dart';
import 'package:teacher_dashboard/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:teacher_dashboard/widgets/upcoming_class.dart';
import 'package:teacher_dashboard/theme/app_theme.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<ClassModel>> _events = {};

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
        // For a more robust solution, you'd need a more complex date generation logic
        for (int i = -30; i <= 30; i++) {
          // Check for classes in a 60-day window
          final date = DateTime.now().add(Duration(days: i));
          if (DateFormat('EEEE').format(date) == dayName) {
            final dayOnly = DateTime(date.year, date.month, date.day);
            if (eventSource[dayOnly] == null) eventSource[dayOnly] = [];
            // Avoid adding duplicate class instances if a class occurs multiple times on the same day (not typical for this model)
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

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final todayString = DateFormat('EEEE, MMM d').format(DateTime.now());
    final selectedDayEvents = _getEventsForDay(_selectedDay ?? DateTime.now());

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Class Schedule',
        subtitle: todayString,
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
      body: Column(
        children: [
          TableCalendar<ClassModel>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AppTheme.accentColor.withAlpha(100),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: AppTheme.accentColor,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: theme.textTheme.titleMedium!,
            ),
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              // Potentially reload events if your event loading is page-dependent
            },
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              DateFormat('EEEE, MMM d').format(_selectedDay ?? DateTime.now()),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: selectedDayEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_busy_outlined,
                          size: 48,
                          color: AppTheme.textSecondary.withAlpha(100),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No classes scheduled for this day.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    itemCount: selectedDayEvents.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final classModel = selectedDayEvents[index];
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
          ),
        ],
      ),
    );
  }
}
