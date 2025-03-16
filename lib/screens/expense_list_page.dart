import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_mobile/services/auth_service.dart';
import '../widgets/select_payers_dialog.dart';
import 'package:intl/intl.dart';

class ExpenseListPage extends StatelessWidget {
  final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('expenses')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> expenseSnapshot) {
        if (!expenseSnapshot.hasData)
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            ),
          );

        if (expenseSnapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "No expenses yet",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Tap the + button to add an expense",
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.only(bottom: 80),
          itemCount: expenseSnapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var expenseDoc = expenseSnapshot.data!.docs[index];
            double price = expenseDoc['price'] ?? 0.0;
            List<dynamic> sharedUsers = expenseDoc['sharedUsers'] ?? [];
            int sharedCount = sharedUsers.isNotEmpty ? sharedUsers.length : 1;
            double splitAmount = price / sharedCount;

            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: Colors.teal[100],
                  child: Icon(Icons.shopping_bag, color: Colors.teal),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        expenseDoc['item'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      currencyFormat.format(price),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[700],
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.grey[600]),
                                children: [
                                  TextSpan(text: "Split: "),
                                  TextSpan(
                                    text: "$sharedCount people",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "Each: ${currencyFormat.format(splitAmount)}",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Delete Expense"),
                        content: Text(
                            "Are you sure you want to delete this expense?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('expenses')
                                  .doc(expenseDoc.id)
                                  .delete();
                              Navigator.pop(context);
                            },
                            child: Text("Delete"),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                onTap: () {
                  showSelectPayersDialog(context, expenseDoc.id, sharedUsers);
                },
              ),
            );
          },
        );
      },
    );
  }
}