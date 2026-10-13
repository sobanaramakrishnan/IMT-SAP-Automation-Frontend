import '../main.dart' show ThemeToggleAction;
import 'package:flutter/material.dart';

class AccountLogin extends StatelessWidget {
  const AccountLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const ThemeToggleAction(),
      body: Center(
        child: Text("Account Login – Coming Soon"),
      ),
    );
  }
}