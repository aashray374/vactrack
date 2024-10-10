import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vactrack/src/provider/auth_state_provider.dart';
import 'package:vactrack/src/screens/add_child.dart';
import 'package:vactrack/src/screens/auth/auth_screen.dart';
import 'package:vactrack/src/screens/profile_page.dart';

class NavDrawr extends StatelessWidget {
  const NavDrawr({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthStateProvider>();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          UserAccountsDrawerHeader(
            accountName: Text(authProvider.username ?? ''),  // Placeholder name without const
            accountEmail: Text(authProvider.email ?? ''),  // Placeholder email without const
            currentAccountPicture: CircleAvatar(
              child: const Icon(Icons.person),  // Use child for placeholder icon
            ),
            decoration: BoxDecoration(
              color: Colors.blue[600],  // Drawer header background color
            ),
          ),
          
          // Profile option
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("View Profile"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profile()),
              );
            },
          ),

          // Appointments option
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text("Appointments"),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const AppointmentsPage()),
              // );
            },
          ),

          // Children option
          ListTile(
            leading: const Icon(Icons.child_care),
            title: const Text("Children"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddChild()),
              );
            },
          ),

          const Divider(),

          // Logout option
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              // Call logout method in the provider
              authProvider.logout();
              
              // Navigate to the AuthScreen and remove all previous routes
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
