import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_dashboard/models/class_model.dart';
import 'package:teacher_dashboard/models/student_model.dart';
import 'package:teacher_dashboard/models/attendance_model.dart';
import 'package:teacher_dashboard/services/attendance_service.dart';
import 'package:teacher_dashboard/theme/app_theme.dart';
import 'package:teacher_dashboard/widgets/sticky_app_bar.dart';
import 'package:animate_do/animate_do.dart';

class ClassDetailPage extends StatefulWidget {
  final ClassModel classModel;

  const ClassDetailPage({super.key, required this.classModel});

  @override
  State<ClassDetailPage> createState() => _ClassDetailPageState();
}

class _ClassDetailPageState extends State<ClassDetailPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isMarkingAttendance = false;

  final Map<String, bool> _attendanceMap = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final attendanceService = Provider.of<AttendanceService>(context);
    final attendanceRecords =
        attendanceService.getAttendanceForClass(widget.classModel.id);

    // Get students for this class
    final List<StudentModel> students =
        attendanceService.getStudentsForClass(widget.classModel.id);

    // Generate mock student data if none exists
    final List<StudentModel> allStudents = students.isNotEmpty
        ? students
        : List.generate(
            widget.classModel.totalStudents,
            (index) => StudentModel(
              id: 'student_${widget.classModel.id}_$index',
              name: 'Student ${index + 1}',
              rollNumber: '${widget.classModel.id}-${index + 1}',
            ),
          );

    // Filter students based on search query
    final filteredStudents = allStudents.where((student) {
      return student.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          student.rollNumber.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    // Initialize attendance map if marking attendance
    if (_isMarkingAttendance && _attendanceMap.isEmpty) {
      for (var student in allStudents) {
        _attendanceMap[student.id] = true; // Default present
      }
    }

    // Calculate attendance statistics
    double averageAttendance = 0;
    if (attendanceRecords.isNotEmpty) {
      final sum = attendanceRecords.fold<double>(
        0,
        (prev, record) => prev + record.attendanceRate,
      );
      averageAttendance = sum / attendanceRecords.length;
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          StickyAppBar(
            title: widget.classModel.name,
            subtitle: widget.classModel.subject,
            expandedHeight: 120.0,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  // Edit class feature
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: FadeIn(
              duration: const Duration(milliseconds: 600),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Class Overview',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getAttendanceColor(
                                        averageAttendance, isDarkMode)
                                    .withAlpha(40),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${averageAttendance.toStringAsFixed(1)}% Avg',
                                style: TextStyle(
                                  color: _getAttendanceColor(
                                      averageAttendance, isDarkMode),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          Icons.calendar_today_outlined,
                          'Schedule:',
                          '${widget.classModel.days.join(", ")} at ${widget.classModel.time}',
                          theme,
                          isDarkMode,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          Icons.room_outlined,
                          'Location:',
                          widget.classModel.room.isEmpty
                              ? 'Not specified'
                              : widget.classModel.room,
                          theme,
                          isDarkMode,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          Icons.people_outline,
                          'Students:',
                          '${widget.classModel.totalStudents} enrolled',
                          theme,
                          isDarkMode,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          Icons.bar_chart_outlined,
                          'Attendance Records:',
                          '${attendanceRecords.length} sessions recorded',
                          theme,
                          isDarkMode,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search students...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isMarkingAttendance = !_isMarkingAttendance;
                        if (!_isMarkingAttendance) {
                          _attendanceMap.clear();
                        }
                      });
                    },
                    icon: Icon(
                      _isMarkingAttendance
                          ? Icons.close
                          : Icons.check_circle_outline,
                    ),
                    label: Text(
                        _isMarkingAttendance ? 'Cancel' : 'Mark Attendance'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isMarkingAttendance
                          ? Theme.of(context).colorScheme.error
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final student = filteredStudents[index];
                return FadeInUp(
                  from: 20,
                  delay: Duration(milliseconds: 50 * index),
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4.0),
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: student.imageUrl.isNotEmpty
                              ? NetworkImage(student.imageUrl) as ImageProvider
                              : const AssetImage(
                                  'assets/images/avatar_placeholder.png'),
                          radius: 20,
                        ),
                        title: Text(student.name),
                        subtitle: Text('Roll #: ${student.rollNumber}'),
                        trailing: _isMarkingAttendance
                            ? Checkbox(
                                value: _attendanceMap[student.id] ?? true,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _attendanceMap[student.id] = value ?? false;
                                  });
                                },
                                activeColor: isDarkMode
                                    ? AppTheme.darkAccentColor
                                    : AppTheme.primaryColor,
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: filteredStudents.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 80), // Bottom padding for FAB
          ),
        ],
      ),
      floatingActionButton: _isMarkingAttendance
          ? FloatingActionButton.extended(
              onPressed: () {
                _saveAttendance(context);
              },
              label: const Text('Save Attendance'),
              icon: const Icon(Icons.save_outlined),
              backgroundColor:
                  isDarkMode ? AppTheme.darkAccentColor : AppTheme.primaryColor,
            )
          : null,
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value,
      ThemeData theme, bool isDarkMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: isDarkMode ? AppTheme.darkAccentColor : AppTheme.primaryColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _saveAttendance(BuildContext context) {
    // Get the current date
    final today = DateTime.now();

    // Create an attendance record
    final attendanceRecord = AttendanceRecord(
      id: 'attendance_${widget.classModel.id}_${today.millisecondsSinceEpoch}',
      classId: widget.classModel.id,
      date: today,
      studentAttendance: Map<String, bool>.from(_attendanceMap),
    );

    // Get the attendance service
    final attendanceService =
        Provider.of<AttendanceService>(context, listen: false);

    // Save the attendance
    attendanceService.addAttendanceRecord(attendanceRecord);

    // Reset UI and show success message
    setState(() {
      _isMarkingAttendance = false;
      _attendanceMap.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Attendance saved: ${attendanceRecord.attendanceRate.toStringAsFixed(1)}% present'),
        backgroundColor:
            attendanceRecord.attendanceRate > 70 ? Colors.green : Colors.orange,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Color _getAttendanceColor(double rate, bool isDarkMode) {
    if (isDarkMode) {
      if (rate >= 80) {
        return const Color(0xFF4CAF50); // Green for dark mode
      } else if (rate >= 60) {
        return const Color(0xFFFFC107); // Amber for dark mode
      } else {
        return const Color(0xFFF44336); // Red for dark mode
      }
    } else {
      if (rate >= 80) {
        return Colors.green;
      } else if (rate >= 60) {
        return Colors.orange;
      } else {
        return Colors.red;
      }
    }
  }
}
