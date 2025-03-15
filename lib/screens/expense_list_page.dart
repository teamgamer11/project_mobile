import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/select_payers_dialog.dart';

class ExpenseListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('expenses').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> expenseSnapshot) {
        if (!expenseSnapshot.hasData) return Center(child: CircularProgressIndicator());

        return ListView(
          children: expenseSnapshot.data!.docs.map((expenseDoc) {
            double price = expenseDoc['price'];
            List<dynamic> sharedUsers = expenseDoc['sharedUsers'] ?? [];
            int sharedCount = sharedUsers.isNotEmpty ? sharedUsers.length : 1;
            double splitAmount = price / sharedCount;

            return ListTile(
              title: Text(expenseDoc['item']),
              subtitle: Text("Total: \$${price.toStringAsFixed(2)} | Each: \$${splitAmount.toStringAsFixed(2)}"),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => FirebaseFirestore.instance.collection('expenses').doc(expenseDoc.id).delete(),
              ),
              onTap: () {
                showSelectPayersDialog(context, expenseDoc.id, sharedUsers);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
