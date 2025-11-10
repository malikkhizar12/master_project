import 'package:flutter/material.dart';
import 'package:focus/core/router/app_router.dart';
import 'package:focus/features/content/domain/entities/course.dart';
import 'package:focus/features/content/domain/entities/book.dart';
import 'package:focus/features/content/presentation/widgets/animated_progress_indicator.dart';

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              _buildWelcomeSection(context, colorScheme),
              const SizedBox(height: 24),

              // Quick Stats
              _buildQuickStats(context, colorScheme),
              const SizedBox(height: 24),

              // Recommended Courses
              _buildSectionHeader(
                context,
                'Recommended Courses',
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
              const SizedBox(height: 12),
              _buildRecommendedCourses(context),

              const SizedBox(height: 24),

              // Recommended Books
              _buildSectionHeader(
                context,
                'Recommended Books',
                onSeeAll: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tap "Books" tab to see all books'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildRecommendedBooks(context),

              const SizedBox(height: 24),

              // Continue Learning
              _buildSectionHeader(
                context,
                'Continue Learning',
                onSeeAll: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tap "Progress" tab to see all progress'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildContinueLearning(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, ColorScheme colorScheme) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.all(20),
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
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ready to continue your learning journey?',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
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

  Widget _buildQuickStats(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Courses',
            '12',
            Icons.school,
            colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Books',
            '8',
            Icons.menu_book,
            colorScheme.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            'Progress',
            '68%',
            Icons.trending_up,
            colorScheme.tertiary,
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Icon(icon, color: color, size: 28),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: color.withValues(alpha: 0.8),
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
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: const Text('See all'),
          ),
      ],
    );
  }

  Widget _buildRecommendedCourses(BuildContext context) {
    final courses = [
      const Course(
        id: '1',
        title: 'Flutter Development',
        description: 'Learn Flutter from scratch',
        instructor: 'John Doe',
        duration: '8 hours',
        rating: 4.8,
        enrolledCount: 1250,
        imageUrl: '',
        category: 'Programming',
        level: 'Beginner',
        isFree: false,
        price: 49.99,
      ),
      const Course(
        id: '2',
        title: 'UI/UX Design',
        description: 'Master design principles',
        instructor: 'Jane Smith',
        duration: '6 hours',
        rating: 4.9,
        enrolledCount: 890,
        imageUrl: '',
        category: 'Design',
        level: 'Intermediate',
        isFree: true,
      ),
    ];

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
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
                  child: _buildCourseCard(context, courses[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, Course course) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width * 0.75;

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

  Widget _buildRecommendedBooks(BuildContext context) {
    final books = [
      const Book(
        id: '1',
        title: 'Clean Code',
        author: 'Robert C. Martin',
        description: 'A Handbook of Agile Software Craftsmanship',
        rating: 4.7,
        pageCount: 464,
        imageUrl: '',
        category: 'Programming',
        language: 'English',
        isFree: false,
        price: 29.99,
      ),
      const Book(
        id: '2',
        title: 'Design Patterns',
        author: 'Gang of Four',
        description: 'Elements of Reusable Object-Oriented Software',
        rating: 4.6,
        pageCount: 395,
        imageUrl: '',
        category: 'Programming',
        language: 'English',
        isFree: true,
      ),
    ];

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
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
                  child: _buildBookCard(context, books[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, Book book) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width * 0.6;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRouter.bookDetailRoute,
          arguments: book,
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
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 90,
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

  Widget _buildContinueLearning(BuildContext context) {
    final inProgressCourses = [
      const Course(
        id: '3',
        title: 'Advanced Flutter',
        description: 'Deep dive into Flutter',
        instructor: 'John Doe',
        duration: '10 hours',
        rating: 4.9,
        enrolledCount: 500,
        imageUrl: '',
        category: 'Programming',
        level: 'Advanced',
        isEnrolled: true,
        progress: 0.65,
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: inProgressCourses.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 100)),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: _buildProgressCard(context, inProgressCourses[index]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProgressCard(BuildContext context, Course course) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRouter.courseDetailRoute,
          arguments: course,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(course.progress * 100).toInt()}% Complete',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
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


