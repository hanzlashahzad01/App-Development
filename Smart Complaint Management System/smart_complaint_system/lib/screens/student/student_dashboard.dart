import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_complaint_system/screens/student/student_profile_screen.dart';
import '../../constants/app_theme.dart';
import '../../models/complaint_model.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../home/home_screen.dart';
import 'student_complaints_screen.dart';
//import 'student_profile_screen.dart';
import 'submit_complaint_screen.dart';
import '../admin/admin_dashboard.dart';
import '../hod/hod_dashboard.dart';
import '../advisor/advisor_dashboard.dart';
import '../student/student_dashboard.dart';
import '../../services/complaint_service.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _selectedIndex = 0;
  List<ComplaintModel> _complaints = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadComplaints();
  }

  Future<void> _loadComplaints() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final user = Provider.of<AuthProvider>(context, listen: false).currentUser!;
      final complaints = await ComplaintService().getStudentComplaints(user.id);
      setState(() {
        _complaints = complaints;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser!;

    return DashboardScaffold(
      title: 'Student Dashboard',
      selectedIndex: _selectedIndex,
      onNavigationItemSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SubmitComplaintScreen(),
                  ),
                ).then((_) => _loadComplaints());
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildDashboard(user),
          const StudentComplaintsScreen(),
          const StudentProfileScreen(),
        ],
      ),
    );
  }

  Widget _buildDashboard(UserModel user) {
    // Calculate stats
    final total = _complaints.length;
    final pending = _complaints.where((c) => c.status == ComplaintStatus.submitted || c.status == ComplaintStatus.inProgress).length;
    final resolved = _complaints.where((c) => c.status == ComplaintStatus.resolved).length;
    final rejected = _complaints.where((c) => c.status == ComplaintStatus.rejected).length;
    final recent = _complaints.take(3).toList();

    return RefreshIndicator(
      onRefresh: _loadComplaints,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${user.name}!',
                      style: AppTheme.headingStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Batch: ${user.batch ?? 'Not assigned'}',
                      style: AppTheme.bodyStyle,
                    ),
                    Text(
                      'Advisor: ${user.batchAdvisorEmail ?? 'Not assigned'}',
                      style: AppTheme.bodyStyle,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Quick Stats
            Text(
              'Quick Stats',
              style: AppTheme.subheadingStyle,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Complaints',
                    total.toString(),
                    Icons.list_alt,
                    AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Pending',
                    pending.toString(),
                    Icons.pending_actions,
                    AppTheme.warningColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Resolved',
                    resolved.toString(),
                    Icons.check_circle,
                    AppTheme.successColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Rejected',
                    rejected.toString(),
                    Icons.cancel,
                    AppTheme.errorColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Recent Activity
            Text(
              'Recent Activity',
              style: AppTheme.subheadingStyle,
            ),
            const SizedBox(height: 16),
            Card(
              child: recent.isEmpty
                  ? const ListTile(
                      title: Text('No recent activity'),
                      subtitle: Text('Your recent complaints will appear here'),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recent.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final complaint = recent[index];
                        return ListTile(
                          title: Text(complaint.title),
                          subtitle: Text(complaint.description),
                          trailing: Text(complaint.status.toString().split('.').last),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTheme.headingStyle.copyWith(
                color: color,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTheme.captionStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}