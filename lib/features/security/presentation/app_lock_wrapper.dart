import 'package:alumea/features/navigation/presentation/app_scaffold.dart';
import 'package:alumea/features/security/application/security_controller.dart';
import 'package:alumea/features/security/presentation/unlock_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLockWrapper extends ConsumerStatefulWidget {
  const AppLockWrapper({super.key});

  @override
  ConsumerState<AppLockWrapper> createState() => _AppLockWrapperState();
}

class _AppLockWrapperState extends ConsumerState<AppLockWrapper> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // When the app is resumed from the background, tell the controller to lock it.
    if (state == AppLifecycleState.resumed) {
      ref.read(securityControllerProvider.notifier).lockApp();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the security controller's state.
    final appLockState = ref.watch(securityControllerProvider);

    return appLockState.when(
      data: (state) {
        // If the state is locked, show the UnlockScreen.
        // Otherwise, show the main app scaffold.
        if (state == AppLockState.locked) {
          return const UnlockScreen();
        }
        return const AppScaffold();
      },
      // Show a loading indicator while the initial lock state is being determined.
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }
}