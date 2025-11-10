import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus/core/router/app_router.dart';
import 'package:focus/features/auth/presentation/cubit/auth_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome${user?.displayName != null ? ', ${user!.displayName}' : ''}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthCubit>().logout();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRouter.loginRoute,
                  (_) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(user?.email ?? 'Unknown user'),
            const SizedBox(height: 16),
            const Text(
              'You are now authenticated.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}



