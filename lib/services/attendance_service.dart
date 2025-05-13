import 'package:flutter/material.dart';
import 'package:teacher_dashboard/models/class_model.dart';
import 'package:teacher_dashboard/models/student_model.dart';
import 'package:teacher_dashboard/models/attendance_model.dart';

class AttendanceService extends ChangeNotifier {
  // Sample data
  final List<ClassModel> _classes = [
    ClassModel(
      id: '1',
      name: 'Computer Science 101',
      subject: 'Introduction to Programming',
      room: 'Room 302',
      days: ['Monday', 'Wednesday'],
      time: '09:00 AM - 10:30 AM',
      totalStudents: 30,
    ),
    ClassModel(
      id: '2',
      name: 'Mathematics 202',
      subject: 'Calculus II',
      room: 'Room 201',
      days: ['Tuesday', 'Thursday'],
      time: '11:00 AM - 12:30 PM',
      totalStudents: 25,
    ),
    ClassModel(
      id: '3',
      name: 'Physics 101',
      subject: 'Mechanics',
      room: 'Lab 105',
      days: ['Monday', 'Friday'],
      time: '02:00 PM - 03:30 PM',
      totalStudents: 28,
    ),
    ClassModel(
      id: '4',
      name: 'Data Structures',
      subject: 'Advanced Programming',
      room: 'Computer Lab 3',
      days: ['Wednesday', 'Friday'],
      time: '04:00 PM - 05:30 PM',
      totalStudents: 22,
    ),
  ];

  final Map<String, List<StudentModel>> _classStudents = {
    '1': [
      StudentModel(id: '101', name: 'Ahmed Hassan', rollNumber: 'CS101-01'),
      StudentModel(id: '102', name: 'Sara Johnson', rollNumber: 'CS101-02'),
      StudentModel(id: '103', name: 'Mohammed Ali', rollNumber: 'CS101-03'),
      StudentModel(id: '104', name: 'Fatima Khan', rollNumber: 'CS101-04'),
      StudentModel(id: '105', name: 'John Smith', rollNumber: 'CS101-05'),
      // Add more students as needed
    ],
    '2': [
      StudentModel(id: '201', name: 'Omar Farooq', rollNumber: 'MATH202-01'),
      StudentModel(id: '202', name: 'Zeinab Ahmed', rollNumber: 'MATH202-02'),
      StudentModel(id: '203', name: 'Emily Johnson', rollNumber: 'MATH202-03'),
      StudentModel(id: '204', name: 'Karim Mahmoud', rollNumber: 'MATH202-04'),
      // Add more students as needed
    ],
    '3': [
      StudentModel(id: '301', name: 'Leila Saleh', rollNumber: 'PHY101-01'),
      StudentModel(id: '302', name: 'Youssef Nabil', rollNumber: 'PHY101-02'),
      StudentModel(id: '303', name: 'Aisha Mohammed', rollNumber: 'PHY101-03'),
      StudentModel(id: '304', name: 'David Wilson', rollNumber: 'PHY101-04'),
      // Add more students as needed
    ],
    '4': [
      StudentModel(id: '401', name: 'Noor Hasan', rollNumber: 'DS202-01'),
      StudentModel(id: '402', name: 'Ali Khaled', rollNumber: 'DS202-02'),
      StudentModel(id: '403', name: 'Maryam Sayed', rollNumber: 'DS202-03'),
      StudentModel(id: '404', name: 'Tariq Mahmoud', rollNumber: 'DS202-04'),
      // Add more students as needed
    ],
  };

  final List<AttendanceRecord> _attendanceRecords = [];
  // Methods to modify data
  void addClass(ClassModel classModel) {
    _classes.add(classModel);
    notifyListeners();
  }

  // Getters
  List<ClassModel> get classes => _classes;
  List<StudentModel> getStudentsForClass(String classId) =>
      _classStudents[classId] ?? [];
  List<AttendanceRecord> getAttendanceForClass(String classId) =>
      _attendanceRecords.where((record) => record.classId == classId).toList();

  // Methods
  void addAttendanceRecord(AttendanceRecord record) {
    // Check if we already have a record for this class on this date
    final existingRecordIndex = _attendanceRecords.indexWhere(
      (r) => r.classId == record.classId && isSameDay(r.date, record.date),
    );

    if (existingRecordIndex != -1) {
      // Update existing record
      _attendanceRecords[existingRecordIndex] = record;
    } else {
      // Add new record
      _attendanceRecords.add(record);
    }

    notifyListeners();
  }

  AttendanceRecord? getAttendanceRecord(String classId, DateTime date) {
    try {
      return _attendanceRecords.firstWhere(
        (record) => record.classId == classId && isSameDay(record.date, date),
      );
    } catch (e) {
      return null;
    }
  }

  Map<String, double> getWeeklyAttendanceStats(String classId) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    Map<String, double> stats = {};

    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      final record = getAttendanceRecord(classId, day);

      if (record != null) {
        stats[_getDayName(day.weekday)] = record.attendanceRate;
      } else {
        stats[_getDayName(day.weekday)] = 0.0;
      }
    }

    return stats;
  }

  // Helper methods
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}
