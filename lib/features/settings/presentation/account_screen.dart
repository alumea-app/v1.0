import 'package:alumea/core/app_theme.dart';
import 'package:alumea/features/auth/application/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDataAsync = ref.watch(currentUserDataProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        // Use a simple back button, which Routemaster handles automatically
      ),
      body: userDataAsync.when(
        data: (user) {
          // If the user data is null (which shouldn't happen if they are logged in,
          // but is a good safe guard), show an error.
          if (user == null) {
            return const Center(child: Text('Could not load user data.'));
          }
          // If we have the user data, display it.
          return ListView(
        children: [
          // --- Account Section ---
          const _SectionHeader(title: 'Manage Your Account'),

          ListTile(
            leading: Icon(Icons.person_2_outlined),
            title: Text('Email Address'),
            subtitle: Text(user.email),
          ),

          ListTile(
            leading: Icon(Icons.lock_outline),
            title: Text('Change your password'),
            onTap: () {
              // TODO: Implement the account deletion flow
            },
          ),

          ListTile(
            leading: Icon(Icons.delete_forever_outlined,
                color: Theme.of(context).colorScheme.error),
            title: Text('Delete Account',
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
            onTap: () {
              // TODO: Implement the account deletion flow
            },
          ),

          const Divider(
            indent: 16,
            endIndent: 16,
            color: AppTheme.darkerGraySurface,
          ),
        ],);
        },
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

// A simple private widget to keep the layout clean and consistent
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
