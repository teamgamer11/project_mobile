import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void showAddPersonDialog(BuildContext context) {
  String name = '';

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Add Person"),
      content: TextField(
        decoration: InputDecoration(labelText: "Name"),
        onChanged: (value) => name = value,
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            FirebaseFirestore.instance.collection('users').add({'name': name});
            Navigator.pop(context);
          },
          child: Text("Add"),
        ),
      ],
    ),
  );
}
