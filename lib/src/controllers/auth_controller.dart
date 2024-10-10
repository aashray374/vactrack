import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

FirebaseAuth auth = FirebaseAuth.instance;

showErrDialog(BuildContext context, String err) {
  FocusScope.of(context).requestFocus(FocusNode());
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Error"),
        content: Text(err),
        actions: <Widget>[
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Ok"),
          ),
        ],
      );
    },
  );
}

Future<bool> signin(String email, String password, BuildContext context) async {
  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    return Future.value(true);
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'invalid-email':
        showErrDialog(context, "Please Enter a valid Email");
        break;
      case 'wrong-password':
        showErrDialog(context, "Wrong Password");
        break;
      case 'user-not-found':
        showErrDialog(context, "User Not Found");
        break;
      case 'user-disabled':
        showErrDialog(context, "Specified User is Disabled");
        break;
      case 'too-many-requests':
        showErrDialog(context, "Too Many requests");
        break;
      case 'operation-not-allowed':
        showErrDialog(context, "Provided Operation is not allowed");
        break;
      default:
        showErrDialog(context, "An undefined Error happened.");
    }
  }
  return Future.value(false);
}

Future<bool> signUp(String name, String email, String password, BuildContext context) async {
  try {
    // Create a user with email and password in Firebase Auth
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Get the user's UID
    String uid = userCredential.user!.uid;

    // Upload user data (name, email) to Firestore
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'createdAt': Timestamp.now(), // Optionally store when the user was created
    });

    return Future.value(true);
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'email-already-in-use':
        showErrDialog(context, "Email Already Exists");
        break;
      case 'invalid-email':
        showErrDialog(context, "Invalid Email Address");
        break;
      case 'weak-password':
        showErrDialog(context, "Please Choose a stronger password");
        break;
      default:
        showErrDialog(context, "An undefined Error happened.");
    }
  } catch (e) {
    showErrDialog(context, "Failed to upload user data to Firestore: $e");
  }
  return Future.value(false);
}
