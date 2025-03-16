import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import
import '../widgets/select_payers_dialog.dart';
import '../widgets/edit_expense_dialog.dart'; // Add this import

class ExpenseListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String uid =
        FirebaseAuth.instance.currentUser!.uid; // Get current user's UID

    return StreamBuilder(
      stream:
          FirebaseFirestore.instance
              .collection('expenses')
              .where('uid', isEqualTo: uid)
              .snapshots(), // Filter by UID
      builder: (context, AsyncSnapshot<QuerySnapshot> expenseSnapshot) {
        if (!expenseSnapshot.hasData)
          return Center(child: CircularProgressIndicator());

        double totalAmount = 0;
        int totalPeople = 0;

        if (expenseSnapshot.data!.docs.isNotEmpty) {
          expenseSnapshot.data!.docs.forEach((expenseDoc) {
            totalAmount += expenseDoc['price'];
            totalPeople += (expenseDoc['sharedUsers'] ?? []).length as int;
          });
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "จำนวนคน",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        totalPeople.toString(),
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "ราคารวม",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        totalAmount.toStringAsFixed(2),
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ชื่อรายการ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "ราคา",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "คนละ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text("ชื่อรายการ")),
                    DataColumn(label: Text("ราคา")),
                    DataColumn(label: Text("คนละ")),
                  ],
                  rows:
                      expenseSnapshot.data!.docs.isNotEmpty
                          ? expenseSnapshot.data!.docs.map((expenseDoc) {
                            double price = expenseDoc['price'];
                            List<dynamic> sharedUsers =
                                expenseDoc['sharedUsers'] ?? [];
                            int sharedCount =
                                sharedUsers.isNotEmpty
                                    ? sharedUsers.length
                                    : 0; // Set to 0 if no payers
                            double splitAmount =
                                sharedCount > 0 ? price / sharedCount : 0;

                            return DataRow(
                              cells: [
                                DataCell(Text(expenseDoc['item'])),
                                DataCell(Text(price.toStringAsFixed(2))),
                                DataCell(Text(splitAmount.toStringAsFixed(2))),
                              ],
                              onSelectChanged: (selected) {
                                if (selected != null && selected) {
                                  showEditExpenseDialog(
                                    context,
                                    expenseDoc.id,
                                    expenseDoc['item'],
                                    price,
                                    sharedUsers,
                                  );
                                }
                              },
                              selected: false, // Ensure the row is not selected
                            );
                          }).toList()
                          : [],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
