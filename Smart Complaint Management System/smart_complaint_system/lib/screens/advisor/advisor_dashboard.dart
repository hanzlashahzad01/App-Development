import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/complaint_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/complaint_service.dart';
import '../auth/login_screen.dart';

class AdvisorDashboard extends StatefulWidget {
  const AdvisorDashboard({super.key});

  @override
  State<AdvisorDashboard> createState() => _AdvisorDashboardState();
}

class _AdvisorDashboardState extends State<AdvisorDashboard> {
  List<ComplaintModel> _complaints = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchComplaints();
  }

  Future<void> _fetchComplaints() async {
    print('Fetching all complaints...');
    try {
      final complaints = await ComplaintService().getAllComplaints();
      print('Complaints fetched: ${complaints.length}');
      for (var c in complaints) {
        print('Complaint: ${c.title}, Student: ${c.studentName}, Status: ${c.status}');
      }
      setState(() {
        _complaints = complaints;
        _loading = false;
      });
    } catch (e) {
      print('Error fetching complaints: $e');
      setState(() {
        _complaints = [];
        _loading = false;
      });
    }
  }

  Future<void> _solveComplaint(ComplaintModel complaint) async {
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser!;
    await ComplaintService().updateComplaintStatus(
      complaint.id,
      ComplaintStatus.resolved,
      user.id,
      user.name,
    );
    _fetchComplaints();
  }

  Future<void> _rejectComplaint(ComplaintModel complaint) async {
    final user = Provider.of<AuthProvider>(context, listen: false).currentUser!;
    await ComplaintService().updateComplaintStatus(
      complaint.id,
      ComplaintStatus.rejected,
      user.id,
      user.name,
    );
    _fetchComplaints();
  }

  Future<void> _forwardToHod(ComplaintModel complaint) async {
    print('Forwarding complaint to HOD: ${complaint.id}');
    try {
      await ComplaintService().updateComplaintStatus(
        complaint.id,
        ComplaintStatus.escalated_to_hod,
        null,
        null,
      );
      print('Forwarded!');
    } catch (e) {
      print('Error forwarding to HOD: $e');
    }
    _fetchComplaints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Batch Advisor Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        final authProvider = Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        );
                        await authProvider.signOut();
                        if (context.mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        }
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _complaints.isEmpty
              ? const Center(child: Text('No complaints assigned.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _complaints.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final c = _complaints[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(c.title),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Description: ${c.description}'),
                                  Text('Status: ${c.status?.toString().split('.').last ?? 'Unknown'}'),
                                  Text('Date: ${c.createdAt != null ? c.createdAt.toLocal().toString().split(".")[0] : 'Unknown'}'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: c.status == ComplaintStatus.resolved || c.status == ComplaintStatus.rejected || c.status == null
                                      ? null
                                      : () => _solveComplaint(c),
                                  child: const Text('Solve'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: c.status == ComplaintStatus.escalated_to_hod || c.status == ComplaintStatus.resolved || c.status == ComplaintStatus.rejected || c.status == null
                                      ? null
                                      : () => _forwardToHod(c),
                                  child: const Text('Forward to HOD'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: c.status == ComplaintStatus.rejected || c.status == ComplaintStatus.resolved || c.status == null
                                      ? null
                                      : () => _rejectComplaint(c),
                                  child: const Text('Reject'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
} 