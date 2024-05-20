import 'package:flutter/material.dart';
import 'package:e_commerce_shopping_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ECommerce Shopping",
      debugShowCheckedModeBanner: false,  // to remove the red banner in the emulator
      theme: ThemeData(
        primaryColor: const Color(0xFFEF6969),
      ),
      home: const SplashScreen(),
    );
  }
}
