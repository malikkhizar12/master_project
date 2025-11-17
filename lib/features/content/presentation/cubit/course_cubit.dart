import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_courses.dart';
import '../../domain/usecases/get_course_by_id.dart';
import '../../domain/usecases/get_recommended_courses.dart';
import '../../domain/usecases/get_enrolled_courses.dart';
import '../../domain/usecases/enroll_in_course.dart';
import '../../../../core/error/failure.dart';
import 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  final GetCourses getCourses;
  final GetCourseById getCourseById;
  final GetRecommendedCourses getRecommendedCourses;
  final GetEnrolledCourses getEnrolledCourses;
  final EnrollInCourse enrollInCourse;

  CourseCubit({
    required this.getCourses,
    required this.getCourseById,
    required this.getRecommendedCourses,
    required this.getEnrolledCourses,
    required this.enrollInCourse,
  }) : super(CourseInitial());

  Future<void> loadCourses({
    String? category,
    String? level,
    String? search,
  }) async {
    emit(CourseLoading());
    try {
      final courses = await getCourses(
        category: category,
        level: level,
        search: search,
      );
      emit(CourseLoaded(courses: courses));
    } on Failure catch (failure) {
      emit(CourseError(failure.message));
    } catch (e) {
      emit(CourseError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> loadCourseById(String id) async {
    emit(CourseLoading());
    try {
      final course = await getCourseById(id);
      emit(CourseDetailLoaded(course: course));
    } on Failure catch (failure) {
      emit(CourseError(failure.message));
    } catch (e) {
      emit(CourseError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> loadRecommendedCourses() async {
    emit(CourseLoading());
    try {
      final courses = await getRecommendedCourses();
      emit(CourseLoaded(courses: courses));
    } on Failure catch (failure) {
      emit(CourseError(failure.message));
    } catch (e) {
      emit(CourseError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> loadEnrolledCourses() async {
    emit(CourseLoading());
    try {
      final courses = await getEnrolledCourses();
      emit(CourseLoaded(courses: courses));
    } on Failure catch (failure) {
      emit(CourseError(failure.message));
    } catch (e) {
      emit(CourseError('Unexpected error: ${e.toString()}'));
    }
  }

  Future<void> enrollCourse(String courseId) async {
    try {
      await enrollInCourse(courseId);
      // Reload courses after enrollment
      await loadCourses();
    } on Failure catch (failure) {
      emit(CourseError(failure.message));
    } catch (e) {
      emit(CourseError('Unexpected error: ${e.toString()}'));
    }
  }
}

