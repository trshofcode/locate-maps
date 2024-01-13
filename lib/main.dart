import 'package:flutter/material.dart';
import 'package:pickme/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pickme/pages/homepage.dart';
import 'package:pickme/pages/splashscreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform
      //     options: FirebaseOptions(
      //   apiKey: "AIzaSyBd4ezEnlZcd5QCmdMz9uds1vs7v9-2OU8",
      //   appId: "1:659738819310:android:7def2cdda3d1b535ce91ff",
      //   messagingSenderId: "659738819310",
      //   projectId: "maps-7232a",
      // )
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber.shade400),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
