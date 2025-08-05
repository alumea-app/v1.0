import 'package:alumea/features/auth/application/auth_controller.dart';
import 'package:alumea/firebase_options.dart';
import 'package:alumea/routes.dart';
import 'package:alumea/core/app_theme.dart';
import 'package:alumea/shared/widgets/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
   await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );
  runApp(
    const ProviderScope(child: AlumeaApp()),
  );
}

class AlumeaApp extends ConsumerWidget {
  const AlumeaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangeProvider);

    return MaterialApp.router(
      title: 'Alumea',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerDelegate: RoutemasterDelegate(
        routesBuilder: (context) {
          return authState.when(
            data: (user) {
              if (user != null) {
                return loggedInRoutes;
              } else {
                return loggedOutRoutes;
              }
            },
            loading: () => RouteMap(
              routes: {
                '/': (_) => const MaterialPage(
                  child: Scaffold(body: Center(child: CircularProgressIndicator())),
                ),
              },
            ),
            error: (error, stack) => RouteMap(
              routes: {
                '/': (_) => MaterialPage(
                  child: ErrorScreen(error: error),
                ),
              },
            ),
          );
        },
      ),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}