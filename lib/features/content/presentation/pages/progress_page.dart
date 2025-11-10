import 'package:flutter/material.dart';
import 'package:focus/features/content/presentation/widgets/animated_circular_progress.dart';
import 'package:focus/features/content/presentation/widgets/animated_progress_indicator.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Progress'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Progress Card
            _buildOverallProgressCard(context, colorScheme),
            const SizedBox(height: 24),

            // Statistics
            Text(
              'Statistics',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatisticsGrid(context, colorScheme),
            const SizedBox(height: 24),

            // Courses in Progress
            Text(
              'Courses in Progress',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCoursesInProgress(context),
            const SizedBox(height: 24),

            // Books in Progress
            Text(
              'Books in Progress',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildBooksInProgress(context),
            const SizedBox(height: 24),

            // Achievements
            Text(
              'Achievements',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildAchievements(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallProgressCard(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    final theme = Theme.of(context);
    final overallProgress = 0.68;

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
  ) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
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
                  '5',
                  Icons.check_circle,
                  Colors.green,
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
                  '7',
                  Icons.play_circle,
                  colorScheme.primary,
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
                  '3',
                  Icons.verified,
                  Colors.amber,
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
                  '12 days',
                  Icons.local_fire_department,
                  Colors.orange,
                ),
              ),
            );
          },
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
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesInProgress(BuildContext context) {
    // Mock data
    final courses = [
      {'title': 'Flutter Development', 'progress': 0.65},
      {'title': 'UI/UX Design', 'progress': 0.40},
      {'title': 'Advanced Flutter', 'progress': 0.85},
    ];

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
                  course['title'] as String,
                  course['progress'] as double,
                  Icons.school,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBooksInProgress(BuildContext context) {
    // Mock data
    final books = [
      {'title': 'Clean Code', 'progress': 0.45},
      {'title': 'Design Patterns', 'progress': 0.30},
    ];

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
                  book['title'] as String,
                  book['progress'] as double,
                  Icons.menu_book,
                ),
              ),
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

  Widget _buildAchievements(BuildContext context) {
    final theme = Theme.of(context);
    final achievements = [
      {'title': 'First Course', 'icon': Icons.emoji_events, 'earned': true},
      {'title': 'Bookworm', 'icon': Icons.menu_book, 'earned': true},
      {'title': 'Week Warrior', 'icon': Icons.calendar_today, 'earned': true},
      {'title': 'Master Learner', 'icon': Icons.star, 'earned': false},
    ];

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
        final isEarned = achievement['earned'] as bool;
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
                        achievement['icon'] as IconData,
                        size: 40,
                        color: isEarned
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        achievement['title'] as String,
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
  }
}

