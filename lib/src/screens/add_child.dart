import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vactrack/src/controllers/child_controller.dart';
import 'package:vactrack/src/screens/add_child_screen.dart';
import 'package:vactrack/src/screens/vaccine_calendar_page.dart';

class AddChild extends StatefulWidget {
  const AddChild({super.key});

  @override
  State<AddChild> createState() => _AddChildState();
}

class _AddChildState extends State<AddChild> {
  List<Map<String, dynamic>> childs = [];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() async {
    List<Map<String, dynamic>>? temp = await getChildren(context);
    if (temp != null) {
      setState(() {
        childs.addAll(temp);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Child"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddChildScreen()),
          );
        },
        child: const Icon(Icons.add), // Added icon for better UX
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: childs.isEmpty
            ? const Center(child: Text('No children added yet'))
            : ListView.builder(
                itemCount: childs.length,
                itemBuilder: (context, index) {
                  // Extract child details
                  String name = childs[index]['name'];
                  String dobString = childs[index]['DOB'];
                  DateTime dob = DateFormat('yMMMd').parse(dobString);
                  
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        backgroundImage: childs[index]['imagePath'] != null
                            ? AssetImage(childs[index]['imagePath'])
                            : const AssetImage('assets/images/default_child.png'),
                        radius: 30,
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'DOB: $dobString',
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return VaccineCalendarPage(dob: dob);
                          },
                        ));
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
