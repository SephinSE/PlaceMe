import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:placeme/app_state.dart';
import 'package:placeme/firebase_options.dart';
import 'package:placeme/pages/auth_page.dart';
import 'package:placeme/pages/edit_profile.dart';
import 'package:placeme/pages/home_page.dart';
import 'package:placeme/pages/post.dart';
import 'package:placeme/pages/profile.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: ((context, child) => const MyApp()),
  ));
}

final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const MyHomePage();
              } else {
                return const PlaceMeAuthPage();
              }
            },
          );
        },
        routes: [
          GoRoute(
              path: 'post',
              builder: (context, state) {
                return const PlaceMePostPage();
              }
          ),
          GoRoute(
              path: 'profile',
              builder: (context, state) {
                return const PlaceMeProfilePage();
              },
              routes: [
                GoRoute(
                    path: 'edit_profile',
                    builder: (context, state) {
                      return const PlaceMeEditProfilePage();
                    }
                )
              ]
          ),
    ]
      )
    ]
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'PlaceMe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
