import 'package:equatable/equatable.dart';

class Course extends Equatable {
  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.duration,
    required this.rating,
    required this.enrolledCount,
    required this.imageUrl,
    required this.category,
    required this.level,
    this.price,
    this.isFree = false,
    this.isEnrolled = false,
    this.progress = 0.0,
  });

  final String id;
  final String title;
  final String description;
  final String instructor;
  final String duration; // e.g., "5 hours", "8 weeks"
  final double rating;
  final int enrolledCount;
  final String imageUrl;
  final String category;
  final String level; // Beginner, Intermediate, Advanced
  final double? price;
  final bool isFree;
  final bool isEnrolled;
  final double progress; // 0.0 to 1.0

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        instructor,
        duration,
        rating,
        enrolledCount,
        imageUrl,
        category,
        level,
        price,
        isFree,
        isEnrolled,
        progress,
      ];
}

