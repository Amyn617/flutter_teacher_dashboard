class AttendanceRecord {
  final String id;
  final String classId;
  final DateTime date;
  final Map<String, bool> studentAttendance; // studentId -> isPresent

  AttendanceRecord({
    required this.id,
    required this.classId,
    required this.date,
    required this.studentAttendance,
  });

  int get presentCount =>
      studentAttendance.values.where((present) => present).length;
  int get absentCount =>
      studentAttendance.values.where((present) => !present).length;
  double get attendanceRate =>
      studentAttendance.isEmpty
          ? 0.0
          : presentCount / studentAttendance.length * 100;
}
