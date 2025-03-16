import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_mobile/screens/home_page.dart';
import '../services/auth_service.dart';
import '../screens/login_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GroupExpenseApp());
}

class GroupExpenseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Group Expense Splitter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthService().currentUser != null ? ExpenseHomePage() : LoginScreen(),
    );
  }
}

