import 'package:equatable/equatable.dart';

class Book extends Equatable {
  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.rating,
    required this.pageCount,
    required this.imageUrl,
    required this.category,
    required this.language,
    this.price,
    this.isFree = false,
    this.isReading = false,
    this.progress = 0.0,
    this.publishedYear,
  });

  final String id;
  final String title;
  final String author;
  final String description;
  final double rating;
  final int pageCount;
  final String imageUrl;
  final String category;
  final String language;
  final double? price;
  final bool isFree;
  final bool isReading;
  final double progress; // 0.0 to 1.0
  final int? publishedYear;

  @override
  List<Object?> get props => [
        id,
        title,
        author,
        description,
        rating,
        pageCount,
        imageUrl,
        category,
        language,
        price,
        isFree,
        isReading,
        progress,
        publishedYear,
      ];
}

