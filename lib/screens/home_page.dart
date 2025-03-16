import 'package:flutter/material.dart';
import 'expense_list_page.dart';
import 'people_list_page.dart';
import 'login_page.dart';
import '../widgets/add_expense_dialog.dart';
import '../widgets/add_person_dialog.dart';
import '../services/auth_service.dart';

class ExpenseHomePage extends StatefulWidget {
  @override
  _ExpenseHomePageState createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [ExpenseListPage(), PeopleListPage()];
  final List<String> _titles = ["Expenses", "People"];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await AuthService().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text("Logout"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            tooltip: "Logout",
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[50],
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Expenses",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "People",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text(_selectedIndex == 0 ? "Add Expense" : "Add Person"),
        backgroundColor: Colors.teal,
        onPressed: () {
          _selectedIndex == 0
              ? showAddExpenseDialog(context)
              : showAddPersonDialog(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}