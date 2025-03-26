import 'package:cipherx/screens/splash_screen.dart';
import 'package:cipherx/utils/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cipherx/screens/getting_start_screen.dart';
//import 'package:cipherx/screens/home_screen.dart';
import 'package:cipherx/screens/auth/login_screen.dart';
import 'package:cipherx/screens/auth/signup_screen.dart';
import 'package:cipherx/config/firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cipherx/widgets/bottom_nav.dart';
import '../dataModels/model/add_data.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AdddataAdapter());
  await Hive.openBox<Add_data>('data');
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  firebaseAuth.authStateChanges().listen((User? user) {
    if (user == null) {
      runApp(const App());
    } else {
      runApp(const MyHomeApp());
    }
  });
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class MyHomeApp extends StatelessWidget {
  const MyHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CypherX',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const Bottom(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/Bottom': (context) => const Bottom(),
      },
    );
  }
}
