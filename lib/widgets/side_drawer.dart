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
            decoration: BoxDecoration(color: Colors.blueGrey),
            child: Text(
              "IndoMetal",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("User Login"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserLogin()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: const Text("Admin Login"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminLogin()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text("Account Login"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AccountLogin()),
              );
            },
          ),
        ],
      ),
    );
  }
}
