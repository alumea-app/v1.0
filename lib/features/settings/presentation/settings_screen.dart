import 'package:alumea/core/app_theme.dart';
import 'package:alumea/features/auth/data/auth_repository.dart';
import 'package:alumea/features/security/application/security_controller.dart';
import 'package:alumea/features/security/data/security_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasPin = ref.watch(securityRepositoryProvider).hasPin();
    final appLockEnabledAsync = ref.watch(appLockEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // --- Account Section ---
          const _SectionHeader(title: 'Account'),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Manage Account'),
            subtitle: const Text('Update your email or password'),
            onTap: () {
              // TODO: Navigate to a future Manage Account screen
              Routemaster.of(context).push('/account');
            },
          ),

          const Divider(
            indent: 16,
            endIndent: 16,
            color: AppTheme.darkerGraySurface,
          ),

          // --- Privacy & Security Section ---
          const _SectionHeader(title: 'Privacy & Security'),
          FutureBuilder<bool>(
            future: hasPin,
            builder: (context, snapshot) {
              return SwitchListTile(
                secondary: const Icon(Icons.lock_outline),
                selectedTileColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
                thumbColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppTheme.lightGrayBackground;
                  }
                  return AppTheme.primaryBlue;
                }),
                trackOutlineColor:
                    WidgetStateProperty.all(AppTheme.primaryBlue),
                title: const Text('App Lock'),
                subtitle: const Text('Secure with biometrics or PIN'),
                value: appLockEnabledAsync.when(
                  data: (isEnabled) => isEnabled,
                  loading: () => false, // Default to off while loading
                  error: (_, __) => false, // Default to off on error
                ),
                onChanged: (bool value) async {
                  final securityRepo = ref.read(securityRepositoryProvider);
                  if (value) {
                    // If turning ON, navigate to the setup screen.
                    // After setup, the provider will automatically refresh.
                    Routemaster.of(context).push('/set-passcode');
                  } else {
                    // If turning OFF, delete the pin.
                    await securityRepo.deletePin();
                  }
                  // Manually refresh the provider to ensure the UI updates.
                  ref.invalidate(appLockEnabledProvider);
                },
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () {
              Routemaster.of(context).push('/privacy-policy');
            },
          ),
          ListTile(
            leading: const Icon(Icons.file_copy_outlined),
            title: const Text('Terms and Conditions'),
            onTap: () {
              Routemaster.of(context).push('/terms-and-conditions');
            },
          ),
          ListTile(
            leading: const Icon(Icons.manage_accounts_outlined),
            title: const Text('Manage My Data'),
            onTap: () {
              // TODO: Launch URL to Privacy Policy
            },
          ),

          const Divider(
            indent: 16,
            endIndent: 16,
            color: AppTheme.darkerGraySurface,
          ),

          const _SectionHeader(title: 'Support & Feedback'),

          ListTile(
            leading: const Icon(Icons.support_agent_outlined),
            title: const Text('Help & Support'),
            onTap: () {
              // TODO: Launch URL to Privacy Policy
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () {
              // Pop the settings page before signing out to avoid seeing it briefly
              Routemaster.of(context).pop();
              ref.read(authRepositoryProvider).signOut();
            },
          ),

          const Divider(
            indent: 16,
            endIndent: 16,
            color: AppTheme.darkerGraySurface,
          ),

          // --- Notifications Section ---
          const _SectionHeader(title: 'Notifications'),
          SwitchListTile(
            thumbColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return AppTheme.lightGrayBackground;
              }
              return AppTheme.primaryBlue;
            }),
            trackOutlineColor: WidgetStateProperty.all(AppTheme.primaryBlue),
            secondary: const Icon(
              Icons.notifications_outlined,
            ),
            title: const Text('Daily Reminders'),
            value: false, // This would come from a provider later
            onChanged: (bool value) {
              // TODO: Implement reminder logic
            },
          ),
        ],
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
