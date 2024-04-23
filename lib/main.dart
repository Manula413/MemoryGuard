import 'package:dementia_care/screens/map.dart';
import 'package:dementia_care/screens/sos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dementia_care/screens/sign_in_screen.dart';
import 'package:dementia_care/screens/sign_up_screen.dart';
import 'package:dementia_care/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // ignore: unused_local_variable
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor:Colors.transparent // set status bar color
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MemoryGuard',
      theme: theme(),
      home: const SignInScreen(),
      routes: {
        '/login': (BuildContext context) => const SignInScreen(),
        '/register': (BuildContext context) => const SignUpScreen(),
        '/user': (BuildContext context) => const SosScreen(),
        '/map': (BuildContext context) => const Map(),
      },
    );
  }
}