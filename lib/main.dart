import 'package:alumea/features/auth/application/auth_controller.dart';
import 'package:alumea/firebase_options.dart';
import 'package:alumea/routes.dart';
import 'package:alumea/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope(child: AlumeaApp()),
  );
}

class AlumeaApp extends ConsumerWidget {
  const AlumeaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the auth state here to decide the initial route
    final authState = ref.watch(authControllerProvider);

    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerDelegate: RoutemasterDelegate(
        routesBuilder: (context) {
          // Based on the auth state, return the correct route map
          if (authState.isLoading) {
            return loggedOutRoutes; // Or a dedicated loading route
          }
          if (authState.hasValue && authState.value != null) {
            return loggedInRoutes;
          }
          return loggedOutRoutes;
        },
      ),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
