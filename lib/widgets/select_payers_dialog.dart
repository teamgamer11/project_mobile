import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

void showSelectPayersDialog(BuildContext context, String expenseId, List<dynamic> currentSharedUsers) {
  final AuthService _authService = AuthService();

  showDialog(
    context: context,
    builder: (context) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').where('addedBy', isEqualTo: _authService.currentUserUid).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
          if (!userSnapshot.hasData) 
            return AlertDialog(
              content: Center(
                child: CircularProgressIndicator(),
              ),
            );

          List<QueryDocumentSnapshot> users = userSnapshot.data!.docs;
          Map<String, bool> selectedUsers = {
            for (var user in users) user.id: currentSharedUsers.contains(user.id)
          };

          return StatefulBuilder(
            builder: (context, setState) {
              int selectedCount = selectedUsers.values.where((v) => v).length;
              
              return AlertDialog(
                title: Row(
                  children: [
                    Icon(Icons.people, color: Colors.teal),
                    SizedBox(width: 10),
                    Expanded(child: Text("Select Who Shares")),
                  ],
                ),
                content: Container(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "$selectedCount ${selectedCount == 1 ? 'person' : 'people'} selected",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 8),
                      Divider(),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            var userDoc = users[index];
                            return CheckboxListTile(
                              title: Text(
                                userDoc['name'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              value: selectedUsers[userDoc.id] ?? false,
                              activeColor: Colors.teal,
                              onChanged: (bool? value) {
                                setState(() {
                                  selectedUsers[userDoc.id] = value!;
                                });
                              },
                              secondary: CircleAvatar(
                                backgroundColor: Colors.teal[100],
                                child: Text(
                                  userDoc['name'][0].toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.teal[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
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
                    icon: Icon(Icons.save),
                    label: Text("Save"),
                    onPressed: () {
                      List<String> newSharedUsers = selectedUsers.entries
                          .where((entry) => entry.value)
                          .map((entry) => entry.key)
                          .toList();

                      FirebaseFirestore.instance
                          .collection('expenses')
                          .doc(expenseId)
                          .update({
                        'sharedUsers': newSharedUsers,
                      });

                      Navigator.pop(context);
                    },
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
