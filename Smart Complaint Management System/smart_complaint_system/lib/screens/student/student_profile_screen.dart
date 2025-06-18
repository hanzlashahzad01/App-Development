import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;
    if (user == null) {
      return const Center(child: Text('No user data found.'));
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: 	${user.name}', style: const TextStyle(fontSize: 18)),
          Text('Email: ${user.email}', style: const TextStyle(fontSize: 18)),
          Text('Batch: ${user.batch ?? 'N/A'}', style: const TextStyle(fontSize: 18)),
          Text('Role: ${user.role.toString().split('.').last}', style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
} 