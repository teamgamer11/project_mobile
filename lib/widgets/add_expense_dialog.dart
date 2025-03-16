import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import

void showAddExpenseDialog(BuildContext context) {
  String itemName = '';
  String price = '';
  final String uid =
      FirebaseAuth.instance.currentUser!.uid; // Get current user's UID

  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text("Add Expense"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Item Name"),
                onChanged: (value) => itemName = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                onChanged: (value) => price = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('expenses').add({
                  'item': itemName,
                  'price': double.tryParse(price) ?? 0.0,
                  'sharedUsers': [],
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
