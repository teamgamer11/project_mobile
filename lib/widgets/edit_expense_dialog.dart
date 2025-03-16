import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'select_payers_dialog.dart'; // Add this import

void showEditExpenseDialog(
  BuildContext context,
  String expenseId,
  String currentItemName,
  double currentPrice,
  List<dynamic> currentSharedUsers, // Add this parameter
) {
  String itemName = currentItemName;
  String price = currentPrice.toString();

  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text("Edit Expense"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Item Name"),
                controller: TextEditingController(text: currentItemName),
                onChanged: (value) => itemName = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text: currentPrice.toString(),
                ),
                onChanged: (value) => price = value,
              ),
              ElevatedButton(
                onPressed:
                    () => showSelectPayersDialog(
                      context,
                      expenseId,
                      currentSharedUsers,
                    ),
                child: Text("Select Shared Users"),
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
                FirebaseFirestore.instance
                    .collection('expenses')
                    .doc(expenseId)
                    .update({
                      'item': itemName,
                      'price': double.tryParse(price) ?? currentPrice,
                    });
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('expenses')
                    .doc(expenseId)
                    .delete();
                Navigator.pop(context);
              },
            ),
          ],
        ),
  );
}
