import '../main.dart' show toggleAppTheme;
import 'package:flutter/material.dart';
import '../screens/user_login.dart';
import '../screens/admin_login.dart';
import '../screens/account_login.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF8B174A),
                  Color(0xFF5B1638),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              "IndoMetal",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Theme.of(context).brightness == Brightness.light
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
            ),
            title: Text(
              Theme.of(context).brightness == Brightness.light
                  ? "Switch to Dark Mode"
                  : "Switch to Light Mode",
            ),
            onTap: toggleAppTheme,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("User Login"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UserLogin(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: const Text("Admin Login"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdminLogin(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text("Account Login"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AccountLogin(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}