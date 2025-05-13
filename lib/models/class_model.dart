class ClassModel {
  final String id;
  final String name;
  final String subject;
  final String room; // Room where the class is held
  final List<String> days; // Days of the week the class meets
  final String time; // Time of the class
  final int totalStudents;

  ClassModel({
    required this.id,
    required this.name,
    required this.subject,
    this.room = '', // Make room optional with default value
    required this.days,
    required this.time,
    required this.totalStudents,
  });
}
