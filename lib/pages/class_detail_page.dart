import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_dashboard/models/class_model.dart';
import 'package:teacher_dashboard/models/student_model.dart'; // Re-added import
import 'package:teacher_dashboard/models/attendance_model.dart';
import 'package:teacher_dashboard/services/attendance_service.dart';
import 'package:teacher_dashboard/widgets/attendance_chart.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class ClassDetailPage extends StatefulWidget {
  final ClassModel classModel;

  const ClassDetailPage({super.key, required this.classModel});

  @override
  State<ClassDetailPage> createState() => _ClassDetailPageState();
}

class _ClassDetailPageState extends State<ClassDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  Map<String, bool> _attendanceMap = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize attendance map
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final attendanceService = Provider.of<AttendanceService>(
        context,
        listen: false,
      );
      final students = attendanceService.getStudentsForClass(
        widget.classModel.id,
      );
      final record = attendanceService.getAttendanceRecord(
        widget.classModel.id,
        _selectedDay,
      );

      if (record != null) {
        setState(() {
          _attendanceMap = Map.from(record.studentAttendance);
        });
      } else {
        final initialMap = <String, bool>{};
        for (final student in students) {
          initialMap[student.id] = false;
        }
        setState(() {
          _attendanceMap = initialMap;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _saveAttendance() {
    final attendanceService = Provider.of<AttendanceService>(
      context,
      listen: false,
    );

    // Create a new attendance record
    final record = AttendanceRecord(
      id: '${widget.classModel.id}_${DateFormat('yyyyMMdd').format(_selectedDay)}',
      classId: widget.classModel.id,
      date: _selectedDay,
      studentAttendance: Map.from(_attendanceMap),
    );

    // Save the record
    attendanceService.addAttendanceRecord(record);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Attendance saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final attendanceService = Provider.of<AttendanceService>(context);
    final students = attendanceService.getStudentsForClass(
      widget.classModel.id,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.classModel.name),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundImage: AssetImage(
                'assets/images/avatar_placeholder.png',
              ),
              radius: 18,
            ),
            onPressed: () {
              // Optional: Navigate to a detailed profile page or action
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Attendance'), Tab(text: 'Students')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAttendanceTab(theme, students, attendanceService),
          _buildStudentsTab(students, theme),
        ],
      ),
    );
  }

  Widget _buildAttendanceTab(
    ThemeData theme,
    List<StudentModel> students,
    AttendanceService attendanceService,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Calendar
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  // Load attendance for the selected day
                  final record = attendanceService.getAttendanceRecord(
                    widget.classModel.id,
                    _selectedDay,
                  );
                  if (record != null) {
                    _attendanceMap = Map.from(record.studentAttendance);
                  } else {
                    _attendanceMap = {
                      for (var student in students) student.id: false,
                    };
                  }
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withAlpha(100),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: theme.textTheme.titleMedium!,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Attendance List
        Text(
          'Mark Attendance for ${DateFormat('MMM d, yyyy').format(_selectedDay)}',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (students.isEmpty)
          const Center(child: Text('No students in this class.'))
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: student.imageUrl.isNotEmpty
                        ? NetworkImage(student.imageUrl)
                        : null,
                    child:
                        student.imageUrl.isEmpty ? Text(student.name[0]) : null,
                  ),
                  title: Text(student.name),
                  trailing: Checkbox(
                    value: _attendanceMap[student.id] ?? false,
                    onChanged: (bool? value) {
                      setState(() {
                        _attendanceMap[student.id] = value ?? false;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          icon: const Icon(Icons.save_alt_outlined),
          label: const Text('Save Attendance'),
          onPressed: _saveAttendance,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        const SizedBox(height: 24),
        // Attendance Chart
        AttendanceChart(
          weeklyData: attendanceService.getWeeklyAttendanceStats(
            widget.classModel.id,
          ),
        ),
      ],
    );
  }

  Widget _buildStudentsTab(List<StudentModel> students, ThemeData theme) {
    if (students.isEmpty) {
      return const Center(
        child: Text('No students enrolled in this class yet.'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: student.imageUrl.isNotEmpty
                  ? NetworkImage(student.imageUrl)
                  : null,
              child: student.imageUrl.isEmpty
                  ? Text(student.name[0].toUpperCase())
                  : null,
            ),
            title: Text(student.name, style: theme.textTheme.titleMedium),
            subtitle: Text('Roll No: ${student.rollNumber}'),
          ),
        );
      },
    );
  }
}
