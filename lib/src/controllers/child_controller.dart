import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<bool> addChild(String name, String adaharNO, String dob) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  DocumentReference doc =
      FirebaseFirestore.instance.collection("PARENTS").doc(uid);
  try {
    await doc.collection("CHILDREN").add({
      'name': name,
      'adahar': adaharNO,
      'DOB': dob,
    }).then((value) {
      return Future.value(true);
    });
    return Future.value(true); 
  } catch (e) {
    print("Failed to add child: $e");
    return Future.value(false); 
  }
}

Future<List<Map<String, dynamic>>?> getChildren(BuildContext context) async {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  DocumentReference parentDoc =
      FirebaseFirestore.instance.collection("PARENTS").doc(uid);

  try {
    QuerySnapshot snapshot = await parentDoc.collection("CHILDREN").get();

    List<Map<String, dynamic>> children = snapshot.docs.map((doc) {
      return {
        'name': doc['name'],
        'adahar': doc['adahar'],
        'DOB': doc['DOB'],
      };
    }).toList();

    return children;
  } catch (e) {
    print("Failed to get children: $e");
    return null; 
  }
}
