import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_books.dart';
import '../../domain/usecases/get_book_by_id.dart';
import '../../domain/usecases/get_recommended_books.dart';
import '../../domain/usecases/get_reading_books.dart';
import '../../domain/usecases/start_reading.dart';
import '../../../../core/error/failure.dart';
import 'book_state.dart';

class BookCubit extends Cubit<BookState> {
  final GetBooks getBooks;
  final GetBookById getBookById;
  final GetRecommendedBooks getRecommendedBooks;
  final GetReadingBooks getReadingBooks;
  final StartReading startReading;

  BookCubit({
    required this.getBooks,
    required this.getBookById,
    required this.getRecommendedBooks,
    required this.getReadingBooks,
    required this.startReading,
  }) : super(BookInitial());

  Future<void> loadBooks({
    String? category,
    String? search,
  }) async {
    emit(BookLoading());
    try {
      final books = await getBooks(
        category: category,
        search: search,
      );
      emit(BookLoaded(books: books));
    } on Failure catch (failure) {
      emit(BookError(failure.message));
    } catch (e) {
      emit(BookError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> loadBookById(String id) async {
    emit(BookLoading());
    try {
      final book = await getBookById(id);
      emit(BookDetailLoaded(book: book));
    } on Failure catch (failure) {
      emit(BookError(failure.message));
    } catch (e) {
      emit(BookError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> loadRecommendedBooks() async {
    emit(BookLoading());
    try {
      final books = await getRecommendedBooks();
      emit(BookLoaded(books: books));
    } on Failure catch (failure) {
      emit(BookError(failure.message));
    } catch (e) {
      emit(BookError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> loadReadingBooks() async {
    emit(BookLoading());
    try {
      final books = await getReadingBooks();
      emit(BookLoaded(books: books));
    } on Failure catch (failure) {
      emit(BookError(failure.message));
    } catch (e) {
      emit(BookError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> startReadingBook(String bookId) async {
    try {
      await startReading(bookId);
      // Reload books after starting reading
      await loadBooks();
    } on Failure catch (failure) {
      emit(BookError(failure.message));
    } catch (e) {
      emit(BookError('Unexpected error: ${e.toString()}'));
    }
  }
}

