import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vactrack/src/controllers/image_controller.dart';


class AuthStateProvider extends ChangeNotifier {
  String? uid;
  String? username;
  String? email;
  String? img;
  bool isUploading = false;

  // Set the user ID from FirebaseAuth
  void setUid() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      uid = currentUser.uid;
      notifyListeners();
    }
  }

  void logout()async {
    uid = null;
    username = null;
    email = null;
    img = null;
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  Future<void> fetchDetails() async {
    if (uid == null) {
      debugPrint("No user ID found.");
      return;
    }

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? user = snapshot.data() as Map<String, dynamic>?;
        if (user != null) {
          username = user['name'];
          email = user['email'];
          img = user['img'];
          notifyListeners();
        }
      } else {
        debugPrint("User document does not exist.");
      }
    } catch (e) {
      debugPrint("Error fetching user data: $e");
    }
  }

  // Update user details (username) in Firestore
  Future<void> updateDetails(String name, BuildContext context) async {
    if (name.trim().isEmpty) {
      _showDialog(context, "Error", "Please fill in the name field.");
      return;
    }

    if (uid == null) {
      _showDialog(context, "Error", "User not authenticated.");
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': name,
      });

      username = name;
      notifyListeners();

      _showDialog(context, "Success", "Profile updated successfully.");
    } catch (e) {
      _showDialog(context, "Error", "Failed to update profile: $e");
    }
  }

  Future<void> imageUpload(BuildContext context) async {
    if (uid == null) {
      _showDialog(context, "Error", "User not authenticated.");
      return;
    }

    try {
      _setUploading(true);

      String? uploadedImageUrl = await pickImageAndUpload(context, uid!, "users");

      if (uploadedImageUrl != null) {
        await _updateImageInFirestore(uploadedImageUrl);
        img = uploadedImageUrl;
        notifyListeners();

        _showDialog(context, "Success", "Image uploaded successfully.");
      }
    } catch (e) {
      _showDialog(context, "Error", "Failed to upload image: $e");
    } finally {
      _setUploading(false);
    }
  }

  Future<void> _updateImageInFirestore(String imageUrl) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'img': imageUrl,
      });
    } catch (e) {
      debugPrint("Failed to update image in Firestore: $e");
    }
  }


  void _setUploading(bool state) {
    isUploading = state;
    notifyListeners();
  }


  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
