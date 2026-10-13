import '../main.dart' show ThemeToggleAction;
import 'package:flutter/material.dart';

class AdminLogin extends StatelessWidget {
  const AdminLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const ThemeToggleAction(),
      body: Center(
        child: Text("Admin Login – Coming Soon"),
      ),
    );
  }
}