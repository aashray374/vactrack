import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<String?> pickImageAndUpload(BuildContext context, String filename,String collection) async {
  final ImagePicker picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    try {
      Uint8List imageBytes = await pickedFile.readAsBytes();
      String downloadUrl = await uploadImageToFirebase(imageBytes, filename,collection);
      return downloadUrl;
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title:const Text("Error"),
          content: Text("Failed to upload image: $e"),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(), 
                child:const Text("OK"))
          ],
        ),
      );
    }
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:const Text("Failed"),
        content:const Text("No image was selected"),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child:const Text("OK"))
        ],
      ),
    );
  }
  return null;
}

Future<String> uploadImageToFirebase(Uint8List imageBytes, String fileName,String collection) async {
  fileName = "$fileName.jpg";
  Reference storageRef = FirebaseStorage.instance
      .ref()
      .child(collection)
      .child(fileName);

  UploadTask uploadTask = storageRef.putData(imageBytes);

  TaskSnapshot snapshot = await uploadTask;
  String downloadUrl = await snapshot.ref.getDownloadURL();

  return downloadUrl;
}

