import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:teacher_dashboard/models/class_model.dart';
import 'package:teacher_dashboard/services/attendance_service.dart';
import 'package:teacher_dashboard/theme/app_theme.dart';
import 'package:teacher_dashboard/widgets/sticky_app_bar.dart';
import 'package:uuid/uuid.dart';

class AddClassPage extends StatefulWidget {
  const AddClassPage({super.key});

  @override
  State<AddClassPage> createState() => _AddClassPageState();
}

class _AddClassPageState extends State<AddClassPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _subjectController = TextEditingController();
  final _roomController = TextEditingController();
  final _timeController = TextEditingController();
  final _studentsController = TextEditingController(text: '20');

  final List<String> _selectedDays = [];
  bool _isLoading = false;

  final List<String> _weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _subjectController.dispose();
    _roomController.dispose();
    _timeController.dispose();
    _studentsController.dispose();
    super.dispose();
  }

  void _showTimePickerDialog() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).cardColor,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      // Calculate end time (1 hour 30 minutes later)
      final endHour = (pickedTime.hour + 1) % 24;
      final endMinute = (pickedTime.minute + 30) % 60;
      final endTime = TimeOfDay(hour: endHour, minute: endMinute);

      // Format as 'HH:MM AM/PM - HH:MM AM/PM'
      final startFormatted = _formatTimeOfDay(pickedTime);
      final endFormatted = _formatTimeOfDay(endTime);

      setState(() {
        _timeController.text = '$startFormatted - $endFormatted';
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hourOfPeriod == 0 ? 12 : timeOfDay.hourOfPeriod;
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void _toggleDaySelection(String day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  void _saveClass() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDays.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one day')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Create a new class
        final attendanceService =
            Provider.of<AttendanceService>(context, listen: false);

        // Generate a unique ID
        const uuid = Uuid();
        final classId = 'class_${uuid.v4()}';

        // Parse total students count
        final totalStudents = int.parse(_studentsController.text);

        // Create the class model
        final newClass = ClassModel(
          id: classId,
          name: _nameController.text,
          subject: _subjectController.text,
          room: _roomController.text,
          time: _timeController.text,
          days: _selectedDays,
          totalStudents: totalStudents,
        );

        // Add to the service
        attendanceService.addClass(newClass);

        // Show success message and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Class ${newClass.name} added successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Go back to previous screen
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding class: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          StickyAppBar(
            title: 'Add New Class',
            subtitle: 'Create a new class for your schedule',
            actions: const [],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FadeInUp(
                duration: const Duration(milliseconds: 600),
                child: Form(
                  key: _formKey,
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
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Class Name',
                              hintText: 'e.g., Advanced Mathematics',
                              prefixIcon: const Icon(Icons.class_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a class name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _subjectController,
                            decoration: InputDecoration(
                              labelText: 'Subject',
                              hintText: 'e.g., Mathematics',
                              prefixIcon: const Icon(Icons.subject),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a subject';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _roomController,
                            decoration: InputDecoration(
                              labelText: 'Room',
                              hintText: 'e.g., Room 101',
                              prefixIcon: const Icon(Icons.room),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a room';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _timeController,
                            readOnly: true,
                            onTap: _showTimePickerDialog,
                            decoration: InputDecoration(
                              labelText: 'Time',
                              hintText: 'e.g., 09:00 AM - 10:30 AM',
                              prefixIcon: const Icon(Icons.access_time),
                              suffixIcon: const Icon(Icons.arrow_drop_down),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a time';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _studentsController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Total Students',
                              hintText: 'e.g., 20',
                              prefixIcon: const Icon(Icons.people_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter number of students';
                              }
                              if (int.tryParse(value) == null ||
                                  int.parse(value) <= 0) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Days',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _weekDays.map((day) {
                              final isSelected = _selectedDays.contains(day);
                              return GestureDetector(
                                onTap: () => _toggleDaySelection(day),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? (isDarkMode
                                            ? AppTheme.darkAccentColor
                                            : AppTheme.primaryColor)
                                        : (isDarkMode
                                            ? Colors.grey[800]
                                            : Colors.grey[200]),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    day.substring(0, 3), // Short day name
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : (isDarkMode
                                              ? Colors.white70
                                              : Colors.black87),
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _saveClass,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator()
                                  : const Text('Save Class'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
