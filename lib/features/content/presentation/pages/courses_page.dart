import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus/core/router/app_router.dart';
import 'package:focus/core/utils/responsive.dart';
import 'package:focus/features/content/domain/entities/course.dart';
import 'package:focus/features/content/presentation/widgets/animated_progress_indicator.dart';
import 'package:focus/features/content/presentation/cubit/course_cubit.dart';
import 'package:focus/features/content/presentation/cubit/course_state.dart';

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
  void initState() {
    super.initState();
    // Load courses from API
    context.read<CourseCubit>().loadCourses();
  }

  void _applyFilters() {
    context.read<CourseCubit>().loadCourses(
      category: _selectedCategory != 'All' ? _selectedCategory : null,
      level: _selectedLevel != 'All' ? _selectedLevel : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // Category Filter
              SizedBox(
                height: responsive.getSpacing(mobile: 50, tablet: 60, desktop: 70),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.horizontalPadding,
                    vertical: responsive.getSpacing(mobile: 8),
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: EdgeInsets.only(right: responsive.getSpacing(mobile: 8)),
                      child: FilterChip(
                        label: Text(
                          category,
                          style: TextStyle(
                            fontSize: 14 * responsive.fontSizeMultiplier,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                          _applyFilters();
                        },
                      ),
                    );
                  },
                ),
              ),

              // Level Filter
              SizedBox(
                height: responsive.getSpacing(mobile: 50, tablet: 60, desktop: 70),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.horizontalPadding,
                    vertical: responsive.getSpacing(mobile: 8),
                  ),
                  itemCount: _levels.length,
                  itemBuilder: (context, index) {
                    final level = _levels[index];
                    final isSelected = _selectedLevel == level;
                    return Padding(
                      padding: EdgeInsets.only(right: responsive.getSpacing(mobile: 8)),
                      child: FilterChip(
                        label: Text(
                          level,
                          style: TextStyle(
                            fontSize: 14 * responsive.fontSizeMultiplier,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedLevel = level;
                          });
                          _applyFilters();
                        },
                      ),
                    );
                  },
                ),
              ),

              // Courses List
              Expanded(
                child: _buildCoursesList(context, responsive),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCoursesList(BuildContext context, Responsive responsive) {
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
                Icon(
                  Icons.error_outline,
                  size: responsive.getIconSize(mobile: 64, tablet: 72, desktop: 80),
                  color: Theme.of(context).colorScheme.error,
                ),
                SizedBox(height: responsive.getSpacing()),
                Text(
                  'Error: ${state.message}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: (Theme.of(context).textTheme.titleMedium?.fontSize ?? 16) * responsive.fontSizeMultiplier,
                  ),
                ),
                SizedBox(height: responsive.getSpacing()),
                ElevatedButton(
                  onPressed: () => _applyFilters(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final courses = state is CourseLoaded ? state.courses : <Course>[];

        if (courses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school_outlined,
                  size: responsive.getIconSize(mobile: 64, tablet: 72, desktop: 80),
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                SizedBox(height: responsive.getSpacing()),
                Text(
                  'No courses found',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: (Theme.of(context).textTheme.titleMedium?.fontSize ?? 16) * responsive.fontSizeMultiplier,
                      ),
                ),
                SizedBox(height: responsive.getSpacing(mobile: 8)),
                TextButton(
                  onPressed: () => _applyFilters(),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        // Use GridView for tablet/desktop, ListView for mobile
        if (responsive.isMobile) {
          return ListView.builder(
            padding: EdgeInsets.all(responsive.horizontalPadding),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return _buildCourseListItem(context, courses[index], responsive);
            },
          );
        } else {
          final crossAxisCount = responsive.getGridColumns(mobile: 1, tablet: 2, desktop: 3);
          return GridView.builder(
            padding: EdgeInsets.all(responsive.horizontalPadding),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: responsive.getSpacing(),
              mainAxisSpacing: responsive.getSpacing(),
              childAspectRatio: responsive.isTablet ? 0.75 : 0.7,
            ),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return _buildCourseListItem(context, courses[index], responsive);
            },
          );
        }
      },
    );
  }

  Widget _buildCourseListItem(BuildContext context, Course course, Responsive responsive) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: responsive.getSpacing()),
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
              height: responsive.isMobile ? 180 : (responsive.isTablet ? 200 : 220),
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
                      size: responsive.getIconSize(mobile: 64, tablet: 72, desktop: 80),
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
              padding: EdgeInsets.all(responsive.getSpacing(mobile: 16, tablet: 20, desktop: 24)),
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
                            fontSize: (theme.textTheme.titleLarge?.fontSize ?? 20) * responsive.fontSizeMultiplier,
                          ),
                          maxLines: responsive.isMobile ? 2 : 3,
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
                    _applyFilters();
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
                    _applyFilters();
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
  void showResults(BuildContext context) {
    // Trigger search when user submits
    final cubit = context.read<CourseCubit>();
    cubit.loadCourses(search: query);
    super.showResults(context);
  }
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
    return BlocProvider<CourseCubit>.value(
      value: context.read<CourseCubit>(),
      child: BlocBuilder<CourseCubit, CourseState>(
        builder: (context, state) {
          if (state is CourseLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final courses = state is CourseLoaded 
              ? state.courses.where((c) => 
                  c.title.toLowerCase().contains(query.toLowerCase()) ||
                  c.description.toLowerCase().contains(query.toLowerCase())
                ).toList()
              : <Course>[];
          
          if (courses.isEmpty) {
            return Center(child: Text('No courses found for: $query'));
          }
          
          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return ListTile(
                title: Text(course.title),
                subtitle: Text(course.instructor),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRouter.courseDetailRoute,
                    arguments: course,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Start typing to search courses...'),
    );
  }
}

