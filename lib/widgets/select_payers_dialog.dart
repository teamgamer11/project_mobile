import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import

void showSelectPayersDialog(BuildContext context, String expenseId, List<dynamic> currentSharedUsers) {
  final String uid = FirebaseAuth.instance.currentUser!.uid; // Get current user's UID

  showDialog(
    context: context,
    builder: (context) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: uid).snapshots(), // Filter by UID
        builder: (context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
          if (!userSnapshot.hasData) return Center(child: CircularProgressIndicator());

          List<QueryDocumentSnapshot> users = userSnapshot.data!.docs;
          Map<String, bool> selectedUsers = {
            for (var user in users) user.id: currentSharedUsers.contains(user.id)
          };

          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text("Select Who Shares"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: users.map((userDoc) {
                    return CheckboxListTile(
                      title: Text(userDoc['name']),
                      value: selectedUsers[userDoc.id] ?? false,
                      onChanged: (bool? value) {
                        setState(() {
                          selectedUsers[userDoc.id] = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      List<String> newSharedUsers = selectedUsers.entries
                          .where((entry) => entry.value)
                          .map((entry) => entry.key)
                          .toList();

                      FirebaseFirestore.instance.collection('expenses').doc(expenseId).update({
                        'sharedUsers': newSharedUsers,
                      });

                      Navigator.pop(context);
                    },
                    child: Text("Save"),
                  ),
                ],
              );
            },
          );
        },
      );
    },
  );
}
