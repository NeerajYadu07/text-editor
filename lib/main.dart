import 'package:docs_clone/models/error_model.dart';
import 'package:docs_clone/repository/auth_repository.dart';
import 'package:docs_clone/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          // these are variable
          // for each firebase project
          apiKey: "AIzaSyBFNLT0trrUK3SAIJMlEkMO-Ws2gDy-NPU",
          authDomain: "docs-app-web.firebaseapp.com",
          projectId: "docs-app-web",
          storageBucket: "docs-app-web.appspot.com",
          messagingSenderId: "276272307432",
          appId: "1:276272307432:web:6f12f8e71ffa5fdc29fd5d",
          measurementId: "G-ZE1VPXDDNB"));
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ErrorModel? errorModel;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    errorModel = await ref.read(authRepositoryProvider).getUserData();
    print(errorModel!.data.toString());
    if (errorModel != null && errorModel!.data != null) {
      print('hi');

      ref.read(userProvider.notifier).state = errorModel!.data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        final user = ref.watch(userProvider);
        if (user != null && user.token.isNotEmpty) {
          return loggedInRoute;
        }
        return loggedOutRoute;
        // return loggedInRoute;
      }),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
