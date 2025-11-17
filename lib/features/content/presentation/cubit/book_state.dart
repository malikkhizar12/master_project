import 'package:equatable/equatable.dart';
import '../../domain/entities/book.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object?> get props => [];
}

class BookInitial extends BookState {}

class BookLoading extends BookState {}

class BookLoaded extends BookState {
  final List<Book> books;

  const BookLoaded({required this.books});

  @override
  List<Object?> get props => [books];
}

class BookDetailLoaded extends BookState {
  final Book book;

  const BookDetailLoaded({required this.book});

  @override
  List<Object?> get props => [book];
}

class BookError extends BookState {
  final String message;

  const BookError(this.message);

  @override
  List<Object?> get props => [message];
}

