import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void showAddExpenseDialog(BuildContext context) {
  String itemName = '';
  String price = '';
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          Icon(Icons.receipt, color: Colors.teal),
          SizedBox(width: 10),
          Text("Add Expense"),
        ],
      ),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Item Name",
                prefixIcon: Icon(Icons.shopping_bag),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an item name';
                }
                return null;
              },
              onChanged: (value) => itemName = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Price",
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onChanged: (value) => price = value,
            ),
          ],
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
              FirebaseFirestore.instance.collection('expenses').add({
                'item': itemName,
                'price': double.tryParse(price) ?? 0.0,
                'sharedUsers': [],
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