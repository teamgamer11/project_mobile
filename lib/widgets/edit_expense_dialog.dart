import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'select_payers_dialog.dart';
import '../services/auth_service.dart';

void showEditExpenseDialog(
  BuildContext context, 
  String expenseId, 
  List<dynamic> currentSharedUsers,
  String currentName,
  double currentPrice
) {
  final AuthService _authService = AuthService();
  String itemName = currentName;
  String price = currentPrice.toString();
  List<dynamic> sharedUsers = List.from(currentSharedUsers);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("แก้ไขรายการ"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: "ชื่อสิ่งของ"),
            controller: TextEditingController(text: itemName),
            onChanged: (value) => itemName = value,
          ),
          TextField(
            decoration: InputDecoration(labelText: "ราคา"),
            keyboardType: TextInputType.number,
            controller: TextEditingController(text: price),
            onChanged: (value) => price = value,
          ),
          SizedBox(height: 20),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('addedBy', isEqualTo: _authService.currentUserUid)
                .snapshots(),
            builder: (context, snapshot) {
              int count = 0;
              if (snapshot.hasData) {
                count = snapshot.data!.docs.length;
              }
              
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  
                  // Show payers selection dialog
                  showSelectPayersDialog(
                    context,
                    expenseId,
                    sharedUsers
                  );
                },
                child: Text("เลือกผู้จ่าย (${sharedUsers.length} คน)"),
              );
            }
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: Text("ยกเลิก")
        ),
        ElevatedButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection('expenses')
                .doc(expenseId)
                .update({
              'item': itemName,
              'price': double.tryParse(price) ?? 0.0,
            });
            Navigator.pop(context);
          },
          child: Text("บันทึก"),
        ),
      ],
    ),
  );
}