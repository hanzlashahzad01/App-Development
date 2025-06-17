import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
// import 'admin/admin_dashboard.dart'; // Commented out as not yet created
// import 'hod/hod_dashboard.dart'; // Commented out as not yet created
// import 'advisor/advisor_dashboard.dart'; // Commented out as not yet created
import '../screens/student/student_dashboard.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      // If user is not logged in, navigate to login screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      // Navigate based on user role
      switch (user.role) {
        case UserRole.student:
          return const StudentDashboard();
        case UserRole.teacher:
          // return const TeacherDashboard(); // Uncomment when created
          return const Scaffold(body: Center(child: Text('Teacher Dashboard (Coming Soon)')));
        case UserRole.hod:
          // return const HodDashboard(); // Uncomment when created
          return const Scaffold(body: Center(child: Text('HOD Dashboard (Coming Soon)')));
        case UserRole.admin:
          // return const AdminDashboard(); // Uncomment when created
          return const Scaffold(body: Center(child: Text('Admin Dashboard (Coming Soon)')));
        default:
          return const Scaffold(body: Center(child: Text('Unknown Role')));
      }
    }
  }
} 