import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus/core/router/app_router.dart';
import 'package:focus/core/utils/responsive.dart';
import 'package:focus/features/content/domain/entities/book.dart';
import 'package:focus/features/content/presentation/widgets/animated_progress_indicator.dart';
import 'package:focus/features/content/presentation/cubit/book_cubit.dart';
import 'package:focus/features/content/presentation/cubit/book_state.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Programming', 'Design', 'Business', 'Self-Help'];

  @override
  void initState() {
    super.initState();
    // Load books from API
    context.read<BookCubit>().loadBooks();
  }

  void _applyFilters() {
    context.read<BookCubit>().loadBooks(
      category: _selectedCategory != 'All' ? _selectedCategory : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: _BookSearchDelegate(),
              );
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

              // Books List
              Expanded(
                child: _buildBooksList(context, responsive),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBooksList(BuildContext context, Responsive responsive) {
    return BlocBuilder<BookCubit, BookState>(
      builder: (context, state) {
        if (state is BookLoading || state is BookInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is BookError) {
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

        final books = state is BookLoaded ? state.books : <Book>[];

        if (books.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu_book_outlined,
                  size: responsive.getIconSize(mobile: 64, tablet: 72, desktop: 80),
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                SizedBox(height: responsive.getSpacing()),
                Text(
                  'No books found',
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
            itemCount: books.length,
            itemBuilder: (context, index) {
              return _buildBookListItem(context, books[index], responsive);
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
              childAspectRatio: responsive.isTablet ? 0.85 : 0.8,
            ),
            itemCount: books.length,
            itemBuilder: (context, index) {
              return _buildBookListItem(context, books[index], responsive);
            },
          );
        }
      },
    );
  }

  Widget _buildBookListItem(BuildContext context, Book book, Responsive responsive) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: responsive.getSpacing()),
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
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRouter.bookDetailRoute,
            arguments: book,
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover
            Container(
              width: responsive.getIconSize(mobile: 80, tablet: 100, desktop: 120),
              height: responsive.getIconSize(mobile: 120, tablet: 150, desktop: 180),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.menu_book,
                size: responsive.getIconSize(mobile: 40, tablet: 50, desktop: 60),
                color: theme.colorScheme.secondary,
              ),
            ),
            SizedBox(width: responsive.getSpacing(mobile: 16)),

            // Book Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          book.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (book.isFree)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'FREE',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.author,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.description,
                    style: theme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${book.rating}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.menu_book_outlined,
                        size: 16,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${book.pageCount} pages',
                        style: theme.textTheme.bodySmall,
                      ),
                      if (book.publishedYear != null) ...[
                        const SizedBox(width: 16),
                        Text(
                          '${book.publishedYear}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (book.isReading && book.progress > 0) ...[
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Reading Progress',
                              style: theme.textTheme.bodySmall,
                            ),
                            Text(
                              '${(book.progress * 100).toInt()}%',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        AnimatedProgressIndicator(
                          value: book.progress,
                          minHeight: 6,
                          valueColor: theme.colorScheme.secondary,
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          book.category,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.tertiary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (book.price != null)
                        Text(
                          '\$${book.price!.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.secondary,
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

}

class _BookSearchDelegate extends SearchDelegate<String> {
  @override
  void showResults(BuildContext context) {
    // Trigger search when user submits
    final cubit = context.read<BookCubit>();
    cubit.loadBooks(search: query);
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
    return BlocProvider<BookCubit>.value(
      value: context.read<BookCubit>(),
      child: BlocBuilder<BookCubit, BookState>(
        builder: (context, state) {
          if (state is BookLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final books = state is BookLoaded 
              ? state.books.where((b) => 
                  b.title.toLowerCase().contains(query.toLowerCase()) ||
                  b.author.toLowerCase().contains(query.toLowerCase()) ||
                  b.description.toLowerCase().contains(query.toLowerCase())
                ).toList()
              : <Book>[];
          
          if (books.isEmpty) {
            return Center(child: Text('No books found for: $query'));
          }
          
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return ListTile(
                title: Text(book.title),
                subtitle: Text(book.author),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRouter.bookDetailRoute,
                    arguments: book,
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
      child: Text('Start typing to search books...'),
    );
  }
}

