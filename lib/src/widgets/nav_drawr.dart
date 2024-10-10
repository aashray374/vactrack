import 'package:flutter/material.dart';
import 'package:vactrack/src/screens/add_child.dart';
import 'package:vactrack/src/screens/profile_page.dart';

class NavDrawr extends StatelessWidget {
  const NavDrawr({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            UserAccountsDrawerHeader(
              accountName: const Text("John Doe"),  // Placeholder name
              accountEmail: const Text("johndoe@gmail.com"),  // Placeholder email
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile.png'), // Placeholder profile image
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

            // Optionally, you can add a logout button
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                // Handle the logout action here
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
  }
}