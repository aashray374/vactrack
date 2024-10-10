import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vactrack/src/controllers/child_controller.dart';

class AddChildScreen extends StatefulWidget {
  const AddChildScreen({super.key});

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();
  DateTime? selectedDate;

  // Function to pick a date
  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // Function to validate and submit form data
  void submitForm() async {
    if (formKey.currentState!.validate()) {
      if (selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a date')),
        );
        return;
      }

      final String name = nameController.text;
      final String aadhar = aadharController.text;
      final String dob = DateFormat('yMMMd').format(selectedDate!);

      bool completed = await addChild(name, aadhar, dob);
      if (completed) {
        Navigator.pop(context);
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Failed to Add Child"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Child"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Form(
                key: formKey, // Attach the form key
                child: Column(
                  children: [
                    // Child Name Field
                    TextFormField(
                      controller: nameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: "Child's Name",
                        prefixIcon: const Icon(Icons.person),
                        border: const OutlineInputBorder(),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the child's name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Aadhar Number Field
                    TextFormField(
                      controller: aadharController,
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: "Aadhar Number",
                        prefixIcon: const Icon(Icons.credit_card),
                        border: const OutlineInputBorder(),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the Aadhar number";
                        }
                        if (value.length != 12) {
                          return "Aadhar number must be 12 digits";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Date of Birth Field (GestureDetector to pick date)
                    GestureDetector(
                      onTap: () {
                        selectDate(context);
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "Date of Birth",
                          prefixIcon: const Icon(Icons.calendar_today),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDate != null
                                  ? DateFormat('yMMMd').format(selectedDate!)
                                  : "Select Date",
                              style: TextStyle(
                                color: selectedDate != null
                                    ? Colors.black
                                    : Colors.grey[600],
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Confirm Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: submitForm,
                  icon: const Icon(Icons.check_circle),
                  label: const Text(
                    "Confirm Details",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
