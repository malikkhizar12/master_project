import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus/core/router/app_router.dart';
import 'package:focus/core/utils/responsive.dart';
import 'package:focus/features/content/domain/entities/course.dart';
import 'package:focus/features/content/domain/entities/book.dart';
import 'package:focus/features/content/presentation/widgets/animated_progress_indicator.dart';
import 'package:focus/features/content/presentation/cubit/course_cubit.dart';
import 'package:focus/features/content/presentation/cubit/course_state.dart';
import 'package:focus/features/content/presentation/cubit/book_cubit.dart';
import 'package:focus/features/content/presentation/cubit/book_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
    
    // Load data from API
    context.read<CourseCubit>().loadRecommendedCourses();
    context.read<BookCubit>().loadRecommendedBooks();
    context.read<CourseCubit>().loadEnrolledCourses();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final responsive = Responsive(context);
            return SingleChildScrollView(
              padding: responsive.padding,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: responsive.maxContentWidth,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    _buildWelcomeSection(context, colorScheme, responsive),
                    SizedBox(height: responsive.getSpacing()),

                    // Quick Stats
                    _buildQuickStats(context, colorScheme, responsive),
                    SizedBox(height: responsive.getSpacing()),

                    // Recommended Courses
                    _buildSectionHeader(
                      context,
                      'Recommended Courses',
                      responsive: responsive,
                      onSeeAll: () {
                        // Navigate using bottom nav - show hint
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tap "Courses" tab to see all courses'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: responsive.getSpacing(mobile: 12)),
                    _buildRecommendedCourses(context, responsive),

                    SizedBox(height: responsive.getSpacing()),

                    // Recommended Books
                    _buildSectionHeader(
                      context,
                      'Recommended Books',
                      responsive: responsive,
                      onSeeAll: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tap "Books" tab to see all books'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: responsive.getSpacing(mobile: 12)),
                    _buildRecommendedBooks(context, responsive),

                    SizedBox(height: responsive.getSpacing()),

                    // Continue Learning
                    _buildSectionHeader(
                      context,
                      'Continue Learning',
                      responsive: responsive,
                      onSeeAll: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tap "Progress" tab to see all progress'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: responsive.getSpacing(mobile: 12)),
                    _buildContinueLearning(context, responsive),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, ColorScheme colorScheme, Responsive responsive) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: Container(
              padding: EdgeInsets.all(responsive.getSpacing(mobile: 20, tablet: 24, desktop: 28)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: (Theme.of(context).textTheme.headlineSmall?.fontSize ?? 24) * responsive.fontSizeMultiplier,
                        ),
                  ),
                  SizedBox(height: responsive.getSpacing(mobile: 8)),
                  Text(
                    'Ready to continue your learning journey?',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: (Theme.of(context).textTheme.bodyLarge?.fontSize ?? 16) * responsive.fontSizeMultiplier,
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickStats(BuildContext context, ColorScheme colorScheme, Responsive responsive) {
    if (responsive.isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Courses',
                  '12',
                  Icons.school,
                  colorScheme.primary,
                  responsive,
                ),
              ),
              SizedBox(width: responsive.getSpacing(mobile: 12)),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Books',
                  '8',
                  Icons.menu_book,
                  colorScheme.secondary,
                  responsive,
                ),
              ),
            ],
          ),
          SizedBox(height: responsive.getSpacing(mobile: 12)),
          _buildStatCard(
            context,
            'Progress',
            '68%',
            Icons.trending_up,
            colorScheme.tertiary,
            responsive,
          ),
        ],
      );
    }
    
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Courses',
            '12',
            Icons.school,
            colorScheme.primary,
            responsive,
          ),
        ),
        SizedBox(width: responsive.getSpacing(mobile: 12)),
        Expanded(
          child: _buildStatCard(
            context,
            'Books',
            '8',
            Icons.menu_book,
            colorScheme.secondary,
            responsive,
          ),
        ),
        SizedBox(width: responsive.getSpacing(mobile: 12)),
        Expanded(
          child: _buildStatCard(
            context,
            'Progress',
            '68%',
            Icons.trending_up,
            colorScheme.tertiary,
            responsive,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
    Responsive responsive,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      builder: (context, animValue, child) {
        return Transform.scale(
          scale: 0.8 + (animValue * 0.2),
          child: Opacity(
            opacity: animValue,
            child: Container(
              padding: EdgeInsets.all(responsive.getSpacing(mobile: 16, tablet: 20, desktop: 24)),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Icon(icon, color: color, size: responsive.getIconSize(mobile: 28, tablet: 32, desktop: 36)),
                  SizedBox(height: responsive.getSpacing(mobile: 8)),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                          fontSize: (Theme.of(context).textTheme.headlineSmall?.fontSize ?? 22) * responsive.fontSizeMultiplier,
                        ),
                  ),
                  SizedBox(height: responsive.getSpacing(mobile: 4)),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: color.withValues(alpha: 0.8),
                          fontSize: (Theme.of(context).textTheme.bodySmall?.fontSize ?? 12) * responsive.fontSizeMultiplier,
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    VoidCallback? onSeeAll,
    Responsive? responsive,
  }) {
    final r = responsive ?? Responsive(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: (Theme.of(context).textTheme.titleLarge?.fontSize ?? 20) * r.fontSizeMultiplier,
              ),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: Text(
              'See all',
              style: TextStyle(fontSize: 14 * r.fontSizeMultiplier),
            ),
          ),
      ],
    );
  }

  Widget _buildRecommendedCourses(BuildContext context, Responsive responsive) {
    return BlocBuilder<CourseCubit, CourseState>(
      builder: (context, state) {
        if (state is CourseLoading || state is CourseInitial) {
          return const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        
        if (state is CourseError) {
          return SizedBox(
            height: 220,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  TextButton(
                    onPressed: () => context.read<CourseCubit>().loadRecommendedCourses(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        
        final courses = state is CourseLoaded ? state.courses : <Course>[];
        
        if (courses.isEmpty) {
          return SizedBox(
            height: 220,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No recommended courses available'),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.read<CourseCubit>().loadRecommendedCourses(),
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            ),
          );
        }

        return SizedBox(
          height: responsive.isMobile ? 220 : 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: responsive.getSpacing(mobile: 0)),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 300 + (index * 100)),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(50 * (1 - value), 0),
                    child: Opacity(
                      opacity: value,
                      child: _buildCourseCard(context, courses[index], responsive),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCourseCard(BuildContext context, Course course, Responsive responsive) {
    final theme = Theme.of(context);
    final width = responsive.getHorizontalItemWidth(
      mobile: responsive.width * 0.75,
      tablet: responsive.width * 0.5,
      desktop: responsive.width * 0.35,
    );

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRouter.courseDetailRoute,
          arguments: course,
        );
      },
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.1),
                    theme.colorScheme.secondary.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.school,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.instructor,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text('${course.rating}', style: theme.textTheme.bodySmall),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.people_outline,
                        size: 16,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text('${course.enrolledCount}', style: theme.textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedBooks(BuildContext context, Responsive responsive) {
    return BlocBuilder<BookCubit, BookState>(
      builder: (context, state) {
        if (state is BookLoading || state is BookInitial) {
          return SizedBox(
            height: responsive.isMobile ? 180 : 220,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        
        if (state is BookError) {
          return SizedBox(
            height: responsive.isMobile ? 180 : 220,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  TextButton(
                    onPressed: () => context.read<BookCubit>().loadRecommendedBooks(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        
        final books = state is BookLoaded ? state.books : <Book>[];
        
        if (books.isEmpty) {
          return SizedBox(
            height: responsive.isMobile ? 180 : 220,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No recommended books available'),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.read<BookCubit>().loadRecommendedBooks(),
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            ),
          );
        }

        return SizedBox(
          height: responsive.isMobile ? 180 : 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: responsive.getSpacing(mobile: 0)),
            itemCount: books.length,
            itemBuilder: (context, index) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 300 + (index * 100)),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(50 * (1 - value), 0),
                    child: Opacity(
                      opacity: value,
                      child: _buildBookCard(context, books[index], responsive),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBookCard(BuildContext context, Book book, Responsive responsive) {
    final theme = Theme.of(context);
    final width = responsive.getHorizontalItemWidth(
      mobile: responsive.width * 0.6,
      tablet: responsive.width * 0.4,
      desktop: responsive.width * 0.25,
    );

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRouter.bookDetailRoute,
          arguments: book,
        );
      },
      child: Container(
        width: width,
        margin: EdgeInsets.only(right: responsive.getSpacing(mobile: 12)),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(responsive.getSpacing(mobile: 12, tablet: 16, desktop: 20)),
          child: Row(
            children: [
              Container(
                width: responsive.getIconSize(mobile: 60, tablet: 70, desktop: 80),
                height: responsive.getIconSize(mobile: 90, tablet: 105, desktop: 120),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.secondary.withValues(alpha: 0.2),
                      theme.colorScheme.tertiary.withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.menu_book,
                  color: theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      book.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text('${book.rating}', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueLearning(BuildContext context, Responsive responsive) {
    return BlocBuilder<CourseCubit, CourseState>(
      builder: (context, state) {
        if (state is CourseLoading || state is CourseInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is CourseError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${state.message}'),
                TextButton(
                  onPressed: () => context.read<CourseCubit>().loadEnrolledCourses(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        final courses = state is CourseLoaded 
            ? state.courses.where((c) => c.isEnrolled && c.progress > 0).toList()
            : <Course>[];
        
        if (courses.isEmpty) {
          return Center(
            child: Text(
              'No courses in progress',
              style: TextStyle(
                fontSize: 16 * responsive.fontSizeMultiplier,
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: responsive.isMobile ? Axis.vertical : Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: responsive.getSpacing(mobile: 0)),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 400 + (index * 100)),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: _buildProgressCard(context, courses[index], responsive),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildProgressCard(BuildContext context, Course course, Responsive responsive) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRouter.courseDetailRoute,
          arguments: course,
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: responsive.getSpacing(mobile: 12)),
        padding: EdgeInsets.all(responsive.getSpacing(mobile: 16, tablet: 20, desktop: 24)),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(responsive.getSpacing(mobile: 12)),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                    size: responsive.getIconSize(mobile: 24, tablet: 28, desktop: 32),
                  ),
                ),
                SizedBox(width: responsive.getSpacing(mobile: 12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: (theme.textTheme.titleMedium?.fontSize ?? 16) * responsive.fontSizeMultiplier,
                        ),
                        maxLines: responsive.isMobile ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: responsive.getSpacing(mobile: 4)),
                      Text(
                        '${(course.progress * 100).toInt()}% Complete',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * responsive.fontSizeMultiplier,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.getSpacing(mobile: 12)),
            AnimatedProgressIndicator(
              value: course.progress,
              minHeight: 8,
            ),
          ],
        ),
      ),
    );
  }
}


