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

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }
  void _logout() async {
    await AuthService().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Expense Splitter'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),  
            onPressed: _logout
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Expenses"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "People"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _selectedIndex == 0
              ? showAddExpenseDialog(context)
              : showAddPersonDialog(context);
        },
      ),
    );
  }
}
