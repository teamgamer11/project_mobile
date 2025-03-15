import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void showAddExpenseDialog(BuildContext context) {
  String itemName = '';
  String price = '';

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
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
        TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            FirebaseFirestore.instance.collection('expenses').add({
              'item': itemName,
              'price': double.tryParse(price) ?? 0.0,
              'sharedUsers': [],
            });
            Navigator.pop(context);
          },
          child: Text("Add"),
        ),
      ],
    ),
  );
}
