import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/view_dc_details.dart';
void main() {
  runApp(const IndoMetalApp());
}

class IndoMetalApp extends StatelessWidget {
  const IndoMetalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IndoMetal',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/view_dc_details': (context) => const ViewDcDetails(),
      },
    );
  }
}
