import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vactrack/src/provider/auth_state_provider.dart';
import 'package:vactrack/src/screens/add_child.dart';
import 'package:vactrack/src/screens/vaccination_list.dart';
import 'package:vactrack/src/widgets/home_screen_tile.dart';
import 'package:vactrack/src/widgets/nav_drawr.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
      final authProvider = Provider.of<AuthStateProvider>(context, listen: false);
      if(authProvider.uid==null){
      authProvider.setUid();
      authProvider.fetchDetails();
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawr(),
      appBar: AppBar(backgroundColor: Colors.blue[600],
      elevation: 0,),
      backgroundColor: Colors.grey[200],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Section with VacTrack title and icons
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "VacTrack",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Children Section
                      _buildIconSection(
                        context,
                        icon: Image.asset(
                          "assets/images/baby.png",
                          height: 60,
                          color: Colors.white,
                        ),
                        label: 'Children',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddChild(),
                          ),
                        ),
                      ),
                      // Appointment Section
                      _buildIconSection(
                        context,
                        icon: const Icon(
                          Icons.calendar_today_rounded,
                          size: 60,
                          color: Colors.white,
                        ),
                        label: 'Appointment',
                        onTap: () {
                          // Add Appointment functionality
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom Section with Vaccination List
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Services",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      HomeScreenTile(
                        img: "assets/images/baby.png",
                        title: "Vaccinations",
                        nextScreen: VaccinationList(),
                      ),
                      // Add more HomeScreenTile widgets here for additional features
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // A helper method to create the Icon sections
  Widget _buildIconSection(
      BuildContext context, {
        required Widget icon,
        required String label,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Card(
            color: Colors.blue[400],
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: icon,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
