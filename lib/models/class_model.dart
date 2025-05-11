class ClassModel {
  final String id;
  final String name;
  final String subject;
  final List<String> days; // Days of the week the class meets
  final String time; // Time of the class
  final int totalStudents;

  ClassModel({
    required this.id,
    required this.name,
    required this.subject,
    required this.days,
    required this.time,
    required this.totalStudents,
  });
}
