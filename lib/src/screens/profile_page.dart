import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vactrack/src/provider/auth_state_provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _nameController = TextEditingController();
  bool _isEditing = false;
  bool _hasChanges = false; // Track if any changes were made

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthStateProvider>();
    _nameController.text = authProvider.username ?? '';
    print(authProvider.username); // Pre-fill with current username
    _nameController.addListener(() {
      setState(() {
        // Mark changes as soon as user starts editing the name
        _hasChanges = _nameController.text != authProvider.username;
      });
    });
  }

  void _saveChanges(AuthStateProvider authProvider) {
    // Call the provider to update username and reset the change flag
    authProvider.updateDetails(_nameController.text, context);
    setState(() {
      _hasChanges = false;
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthStateProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.blue,  // Blue theme for AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header with image and basic details
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 48),
                    GestureDetector(
                      onTap: () async {
                        await authProvider.imageUpload(context);
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: authProvider.img != null && authProvider.img!.isNotEmpty
                                ? NetworkImage(authProvider.img!)
                                : null,
                            child: authProvider.isUploading
                                ? const CircularProgressIndicator() // Show loader when uploading
                                : authProvider.img == null || authProvider.img!.isEmpty
                                    ? const Icon(Icons.person, size: 50)
                                    : null,
                          ),
                          if (!authProvider.isUploading)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: Colors.blue,
                                radius: 16,
                                child: const Icon(Icons.edit, color: Colors.white, size: 18),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _isEditing
                          ? TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                            )
                          : authProvider.username != null
                              ? Text(
                                  authProvider.username!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : const CircularProgressIndicator(),
                    ),
                    const SizedBox(height: 8),
                    Text(authProvider.email ?? ""),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Profile details form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
                    width: double.infinity,
                    child: _isEditing
                        ? TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your name',
                            ),
                          )
                        : Text(
                            authProvider.username ?? "Loading...",
                            style: const TextStyle(fontSize: 16),
                          ),
                  ),
                  const SizedBox(height: 24),
                  const Text("Email", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
                    width: double.infinity,
                    child: Text(
                      authProvider.email ?? 'Loading...',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // Save button will only be enabled if there are unsaved changes
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue, // Blue theme button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _hasChanges
                                ? () => _saveChanges(authProvider)
                                : null, // Disable button if no changes
                            child: const Text("Save"),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Edit button toggles the editing state
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[300], // Lighter blue for Edit
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _isEditing = !_isEditing; // Toggle edit state
                              });
                            },
                            child: Text(_isEditing ? "Cancel" : "Edit"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
