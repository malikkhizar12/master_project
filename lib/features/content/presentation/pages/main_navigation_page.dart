import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus/core/di/service_locator.dart';
import 'package:focus/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:focus/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:focus/features/content/presentation/pages/home_page.dart';
import 'package:focus/features/content/presentation/pages/courses_page.dart';
import 'package:focus/features/content/presentation/pages/books_page.dart';
import 'package:focus/features/content/presentation/pages/progress_page.dart';
import 'package:focus/features/content/presentation/pages/profile_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const CoursesPage(),
    const BooksPage(),
    const ProgressPage(),
    const ProfilePage(),
  ];

  void setIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>.value(
      value: sl<AuthCubit>(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ProfileCubit>(
            create: (_) => sl<ProfileCubit>(),
          ),
        ],
        child: Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.school_outlined),
              selectedIcon: Icon(Icons.school),
              label: 'Courses',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book),
              label: 'Books',
            ),
            NavigationDestination(
              icon: Icon(Icons.track_changes_outlined),
              selectedIcon: Icon(Icons.track_changes),
              label: 'Progress',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
        ),
      ),
    );
  }
}

