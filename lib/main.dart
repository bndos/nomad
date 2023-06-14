import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nomad/home_page.dart';

import 'package:nomad/services/places_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await PlacesService
      .initialize(); // Call initialize() to initialize the PlacesService

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // default background color for the whole app
      theme: ThemeData(
        primaryColor: Colors.grey.shade900,
      ),
      color: Colors.white,
      title: 'My App',
      home: const HomePage(),
    );
  }
}
