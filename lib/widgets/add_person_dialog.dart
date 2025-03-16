import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void showAddPersonDialog(BuildContext context) {
  String name = '';
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          Icon(Icons.person_add, color: Colors.teal),
          SizedBox(width: 10),
          Text("Add Person"),
        ],
      ),
      content: Form(
        key: formKey,
        child: TextFormField(
          autofocus: true,
          decoration: InputDecoration(
            labelText: "Name",
            prefixIcon: Icon(Icons.person),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a name';
            }
            return null;
          },
          onChanged: (value) => name = value,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton.icon(
          icon: Icon(Icons.add),
          label: Text("Add"),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              FirebaseFirestore.instance.collection('users').add({
                'name': name,
                'timestamp': FieldValue.serverTimestamp(),
              });
              Navigator.pop(context);
            }
          },
        ),
      ],
    ),
  );
}