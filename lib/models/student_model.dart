class StudentModel {
  final String id;
  final String name;
  final String rollNumber;
  final String imageUrl;

  StudentModel({
    required this.id,
    required this.name,
    required this.rollNumber,
    this.imageUrl = '',
  });
}
