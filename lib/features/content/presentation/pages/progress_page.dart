import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus/core/utils/responsive.dart';
import 'package:focus/features/content/presentation/widgets/animated_circular_progress.dart';
import 'package:focus/features/content/presentation/widgets/animated_progress_indicator.dart';
import 'package:focus/features/content/presentation/cubit/progress_cubit.dart';
import 'package:focus/features/content/presentation/cubit/progress_state.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage>
    with SingleTickerProviderStateMixin {
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
    
    // Load progress data from API
    context.read<ProgressCubit>().loadAllProgressData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = Responsive(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Progress'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: responsive.padding,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: responsive.maxContentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overall Progress Card
                  _buildOverallProgressCard(context, colorScheme, responsive),
                  SizedBox(height: responsive.getSpacing()),

                  // Statistics
                  Text(
                    'Statistics',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: (theme.textTheme.titleLarge?.fontSize ?? 20) * responsive.fontSizeMultiplier,
                    ),
                  ),
                  SizedBox(height: responsive.getSpacing(mobile: 16)),
                  _buildStatisticsGrid(context, colorScheme, responsive),
                  SizedBox(height: responsive.getSpacing()),

                  // Courses in Progress
                  Text(
                    'Courses in Progress',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: (theme.textTheme.titleLarge?.fontSize ?? 20) * responsive.fontSizeMultiplier,
                    ),
                  ),
                  SizedBox(height: responsive.getSpacing(mobile: 16)),
                  _buildCoursesInProgress(context, responsive),
                  SizedBox(height: responsive.getSpacing()),

                  // Books in Progress
                  Text(
                    'Books in Progress',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: (theme.textTheme.titleLarge?.fontSize ?? 20) * responsive.fontSizeMultiplier,
                    ),
                  ),
                  SizedBox(height: responsive.getSpacing(mobile: 16)),
                  _buildBooksInProgress(context, responsive),
                  SizedBox(height: responsive.getSpacing()),

                  // Achievements
                  Text(
                    'Achievements',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: (theme.textTheme.titleLarge?.fontSize ?? 20) * responsive.fontSizeMultiplier,
                    ),
                  ),
                  SizedBox(height: responsive.getSpacing(mobile: 16)),
                  _buildAchievements(context, responsive),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverallProgressCard(
    BuildContext context,
    ColorScheme colorScheme,
    Responsive responsive,
  ) {
    return BlocBuilder<ProgressCubit, ProgressState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        double overallProgress = 0.68;
        
        if (state is ProgressDataLoaded) {
          overallProgress = (state.progress['overallProgress'] ?? 0.68) as double;
        } else if (state is ProgressLoaded) {
          overallProgress = (state.progress['overallProgress'] ?? 0.68) as double;
        }

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.primary.withValues(alpha: 0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                'Overall Progress',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              AnimatedCircularProgress(
                value: overallProgress,
                size: 120,
                strokeWidth: 12,
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                valueColor: Colors.white,
                child: Text(
                  '${(overallProgress * 100).toInt()}%',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildProgressStat(context, '12', 'Courses', Colors.white),
                  _buildProgressStat(context, '8', 'Books', Colors.white),
                  _buildProgressStat(context, '45', 'Hours', Colors.white),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressStat(
    BuildContext context,
    String value,
    String label,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: color.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsGrid(
    BuildContext context,
    ColorScheme colorScheme,
    Responsive responsive,
  ) {
    return BlocBuilder<ProgressCubit, ProgressState>(
      builder: (context, state) {
        Map<String, dynamic> stats = {
          'completed': 5,
          'inProgress': 7,
          'certificates': 3,
          'streak': '12 days',
        };
        
        if (state is ProgressDataLoaded) {
          stats = state.statistics;
        } else if (state is StatisticsLoaded) {
          stats = state.statistics;
        }
        
        final crossAxisCount = responsive.isMobile ? 2 : (responsive.isTablet ? 3 : 4);
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: responsive.getSpacing(mobile: 12),
          mainAxisSpacing: responsive.getSpacing(mobile: 12),
          childAspectRatio: responsive.isMobile ? 1.5 : (responsive.isTablet ? 1.3 : 1.2),
          children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 400),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (value * 0.2),
              child: Opacity(
                opacity: value,
                child: _buildStatCard(
                  context,
                  'Completed',
                  '${stats['completed'] ?? 5}',
                  Icons.check_circle,
                  Colors.green,
                  responsive,
                ),
              ),
            );
          },
        ),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 500),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (value * 0.2),
              child: Opacity(
                opacity: value,
                child: _buildStatCard(
                  context,
                  'In Progress',
                  '${stats['inProgress'] ?? 7}',
                  Icons.play_circle,
                  colorScheme.primary,
                  responsive,
                ),
              ),
            );
          },
        ),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (value * 0.2),
              child: Opacity(
                opacity: value,
                child: _buildStatCard(
                  context,
                  'Certificates',
                  '${stats['certificates'] ?? 3}',
                  Icons.verified,
                  Colors.amber,
                  responsive,
                ),
              ),
            );
          },
        ),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 700),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (value * 0.2),
              child: Opacity(
                opacity: value,
                child: _buildStatCard(
                  context,
                  'Streak',
                  '${stats['streak'] ?? '12 days'}',
                  Icons.local_fire_department,
                  Colors.orange,
                  responsive,
                ),
              ),
            );
          },
        ),
      ],
    );
      },
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
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(responsive.getSpacing(mobile: 16, tablet: 20, desktop: 24)),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: responsive.getIconSize(mobile: 32, tablet: 36, desktop: 40)),
          SizedBox(height: responsive.getSpacing(mobile: 8)),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: (theme.textTheme.headlineSmall?.fontSize ?? 22) * responsive.fontSizeMultiplier,
            ),
          ),
          SizedBox(height: responsive.getSpacing(mobile: 4)),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color.withValues(alpha: 0.8),
              fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * responsive.fontSizeMultiplier,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesInProgress(BuildContext context, Responsive responsive) {
    return BlocBuilder<ProgressCubit, ProgressState>(
      builder: (context, state) {
        List<Map<String, dynamic>> courses = [];
        
        if (state is ProgressDataLoaded) {
          courses = state.coursesInProgress;
        } else if (state is CoursesInProgressLoaded) {
          courses = state.courses;
        }
        
        if (courses.isEmpty) {
          return const Center(child: Text('No courses in progress'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 300 + (index * 100)),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: _buildProgressItem(
                      context,
                      course['title']?.toString() ?? 'Course',
                      (course['progress'] ?? 0.0) as double,
                      Icons.school,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildBooksInProgress(BuildContext context, Responsive responsive) {
    return BlocBuilder<ProgressCubit, ProgressState>(
      builder: (context, state) {
        List<Map<String, dynamic>> books = [];
        
        if (state is ProgressDataLoaded) {
          books = state.booksInProgress;
        } else if (state is BooksInProgressLoaded) {
          books = state.books;
        }
        
        if (books.isEmpty) {
          return const Center(child: Text('No books in progress'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 300 + (index * 100)),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: _buildProgressItem(
                      context,
                      book['title']?.toString() ?? 'Book',
                      (book['progress'] ?? 0.0) as double,
                      Icons.menu_book,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildProgressItem(
    BuildContext context,
    String title,
    double progress,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedProgressIndicator(
                  value: progress,
                  minHeight: 6,
                ),
                const SizedBox(height: 4),
                Text(
                  '${(progress * 100).toInt()}% Complete',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements(BuildContext context, Responsive responsive) {
    return BlocBuilder<ProgressCubit, ProgressState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        List<Map<String, dynamic>> achievements = [];
        
        if (state is ProgressDataLoaded) {
          achievements = state.achievements;
        } else if (state is AchievementsLoaded) {
          achievements = state.achievements;
        }
        
        if (achievements.isEmpty) {
          return const Center(child: Text('No achievements yet'));
        }

        return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final achievement = achievements[index];
            final isEarned = achievement['earned'] ?? false;
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 300 + (index * 100)),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (value * 0.2),
              child: Opacity(
                opacity: value,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isEarned
                        ? theme.colorScheme.primary.withValues(alpha: 0.1)
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isEarned
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getIconData(achievement['icon']),
                        size: 40,
                        color: isEarned
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        achievement['title']?.toString() ?? 'Achievement',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isEarned
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
          },
        );
      },
    );
  }
  
  IconData _getIconData(dynamic icon) {
    if (icon is IconData) return icon;
    // Map string icon names to IconData if needed
    switch (icon?.toString()) {
      case 'emoji_events':
        return Icons.emoji_events;
      case 'menu_book':
        return Icons.menu_book;
      case 'calendar_today':
        return Icons.calendar_today;
      case 'star':
        return Icons.star;
      default:
        return Icons.star;
    }
  }
}

