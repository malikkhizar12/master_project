import 'package:flutter/material.dart';
import 'package:focus/core/router/app_router.dart';
import 'package:focus/features/content/domain/entities/course.dart';
import 'package:focus/features/content/presentation/widgets/animated_progress_indicator.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  String _selectedCategory = 'All';
  String _selectedLevel = 'All';

  final List<String> _categories = ['All', 'Programming', 'Design', 'Business', 'Marketing'];
  final List<String> _levels = ['All', 'Beginner', 'Intermediate', 'Advanced'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _CourseSearchDelegate(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Level Filter
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _levels.length,
              itemBuilder: (context, index) {
                final level = _levels[index];
                final isSelected = _selectedLevel == level;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(level),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedLevel = level;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Courses List
          Expanded(
            child: _buildCoursesList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesList(BuildContext context) {
    // Mock data - replace with actual data
    final courses = _getMockCourses();

    if (courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No courses found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return _buildCourseListItem(context, courses[index]);
      },
    );
  }

  Widget _buildCourseListItem(BuildContext context, Course course) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRouter.courseDetailRoute,
            arguments: course,
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.school,
                      size: 64,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  if (course.isEnrolled)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Enrolled',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Course Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          course.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (course.isFree)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'FREE',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.instructor,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 18,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${course.rating}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.people_outline,
                        size: 18,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${course.enrolledCount}',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          course.level,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (course.isEnrolled && course.progress > 0) ...[
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: theme.textTheme.bodySmall,
                            ),
                            Text(
                              '${(course.progress * 100).toInt()}%',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        AnimatedProgressIndicator(
                          value: course.progress,
                          minHeight: 6,
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            course.duration,
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      if (course.price != null)
                        Text(
                          '\$${course.price!.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
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

  List<Course> _getMockCourses() {
    return [
      const Course(
        id: '1',
        title: 'Complete Flutter Development Bootcamp',
        description: 'Learn Flutter from scratch to advanced',
        instructor: 'John Doe',
        duration: '12 hours',
        rating: 4.8,
        enrolledCount: 1250,
        imageUrl: '',
        category: 'Programming',
        level: 'Beginner',
        isFree: false,
        price: 49.99,
        isEnrolled: true,
        progress: 0.65,
      ),
      const Course(
        id: '2',
        title: 'UI/UX Design Masterclass',
        description: 'Master design principles and tools',
        instructor: 'Jane Smith',
        duration: '8 hours',
        rating: 4.9,
        enrolledCount: 890,
        imageUrl: '',
        category: 'Design',
        level: 'Intermediate',
        isFree: true,
      ),
      const Course(
        id: '3',
        title: 'Advanced Flutter Patterns',
        description: 'Deep dive into Flutter architecture',
        instructor: 'John Doe',
        duration: '10 hours',
        rating: 4.7,
        enrolledCount: 500,
        imageUrl: '',
        category: 'Programming',
        level: 'Advanced',
        isFree: false,
        price: 79.99,
      ),
    ];
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Courses'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Category'),
            Wrap(
              spacing: 8,
              children: _categories.map((category) {
                return FilterChip(
                  label: Text(category),
                  selected: _selectedCategory == category,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Level'),
            Wrap(
              spacing: 8,
              children: _levels.map((level) {
                return FilterChip(
                  label: Text(level),
                  selected: _selectedLevel == level,
                  onSelected: (selected) {
                    setState(() {
                      _selectedLevel = level;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _CourseSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text('Search results for: $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Start typing to search courses...'),
    );
  }
}

