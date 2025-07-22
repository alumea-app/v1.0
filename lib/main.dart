import 'package:alumea/features/auth/application/auth_controller.dart';
import 'package:alumea/firebase_options.dart';
import 'package:alumea/routes.dart';
import 'package:alumea/core/app_theme.dart';
import 'package:alumea/shared/models/user_model.dart';
import 'package:alumea/shared/widgets/error_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(child: AlumeaApp()),
  );
}

class AlumeaApp extends ConsumerStatefulWidget {
  const AlumeaApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<AlumeaApp> {
  UserModel? userModel;
  
   void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }
@override
  Widget build(BuildContext context) {

    return ref.watch(authStateChangeProvider).when(
     data: (data) => MaterialApp.router(
      title: 'Alumea',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerDelegate: RoutemasterDelegate(
        routesBuilder: (context) {
            if (data != null) {
               getData(ref, data);
               if (userModel != null) {
                    return loggedInRoutes;
            }
            }
                return loggedOutRoutes; // User is logged out
            },
      ),
      routeInformationParser: const RoutemasterParser(),
    ),
    error: (error, stackTrace) => ErrorScreen(error: error.toString()),
    loading: () => const CircularProgressIndicator(),
    );
  }
}