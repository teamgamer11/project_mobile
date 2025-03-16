import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import

void showAddPersonDialog(BuildContext context) {
  String name = '';
  final String uid =
      FirebaseAuth.instance.currentUser!.uid; // Get current user's UID

  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text("Add Person"),
          content: TextField(
            decoration: InputDecoration(labelText: "Name"),
            onChanged: (value) => name = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('users').add({
                  'name': name,
                  'uid': uid, // Add UID to the document
                });
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        ),
  );
}
