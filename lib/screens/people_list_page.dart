import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import

class PeopleListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String uid =
        FirebaseAuth.instance.currentUser!.uid; // Get current user's UID

    return StreamBuilder(
      stream:
          FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: uid)
              .snapshots(), // Filter by UID
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView(
          children:
              snapshot.data!.docs.map((doc) {
                return ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text(doc['name']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed:
                        () =>
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(doc.id)
                                .delete(),
                  ),
                );
              }).toList(),
        );
      },
    );
  }
}
