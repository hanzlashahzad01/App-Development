import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';

class DashboardScaffold extends StatelessWidget {
  final String title;
  final int selectedIndex;
  final ValueChanged<int> onNavigationItemSelected;
  final Widget body;
  final FloatingActionButton? floatingActionButton;

  const DashboardScaffold({
    super.key,
    required this.title,
    required this.selectedIndex,
    required this.onNavigationItemSelected,
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onNavigationItemSelected,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'My Complaints',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textHintColor,
        backgroundColor: AppTheme.cardColor,
      ),
      floatingActionButton: floatingActionButton,
    );
  }
} 