import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_theme.dart';
import '../../models/complaint_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/complaint_service.dart';
import 'complaint_details_screen.dart';

class StudentComplaintsScreen extends StatefulWidget {
  const StudentComplaintsScreen({super.key});

  @override
  State<StudentComplaintsScreen> createState() => _StudentComplaintsScreenState();
}

class _StudentComplaintsScreenState extends State<StudentComplaintsScreen> {
  final _complaintService = ComplaintService();
  List<ComplaintModel> _complaints = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadComplaints();
  }

  Future<void> _loadComplaints() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final studentId = context.read<AuthProvider>().currentUser!.id;
      final complaints = await _complaintService.getStudentComplaints(studentId);

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Complaints'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadComplaints,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error loading complaints',
                          style: AppTheme.bodyStyle,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _loadComplaints,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : _complaints.isEmpty
                    ? Center(
                        child: Text(
                          'No complaints yet',
                          style: AppTheme.bodyStyle,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _complaints.length,
                        itemBuilder: (context, index) {
                          final complaint = _complaints[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ComplaintDetailsScreen(
                                      complaint: complaint,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          _getStatusIcon(complaint.status),
                                          color: _getStatusColor(complaint.status),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            complaint.title,
                                            style: AppTheme.subheadingStyle,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(complaint.status)
                                                .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            _getStatusText(complaint.status),
                                            style: AppTheme.captionStyle.copyWith(
                                              color: _getStatusColor(complaint.status),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      complaint.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTheme.bodyStyle,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _formatDate(complaint.createdAt),
                                          style: AppTheme.captionStyle,
                                        ),
                                        if (complaint.currentHandlerName != null)
                                          Text(
                                            'Handled by ${complaint.currentHandlerName}',
                                            style: AppTheme.captionStyle,
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }

  IconData _getStatusIcon(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.submitted:
        return Icons.send;
      case ComplaintStatus.inProgress:
        return Icons.pending_actions;
      case ComplaintStatus.escalatedToHod:
        return Icons.escalator_warning;
      case ComplaintStatus.resolved:
        return Icons.check_circle;
      case ComplaintStatus.rejected:
        return Icons.cancel;
    }
  }

  Color _getStatusColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.submitted:
        return AppTheme.primaryColor;
      case ComplaintStatus.inProgress:
        return AppTheme.warningColor;
      case ComplaintStatus.escalatedToHod:
        return AppTheme.accentColor;
      case ComplaintStatus.resolved:
        return AppTheme.successColor;
      case ComplaintStatus.rejected:
        return AppTheme.errorColor;
    }
  }

  String _getStatusText(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.submitted:
        return 'Submitted';
      case ComplaintStatus.inProgress:
        return 'In Progress';
      case ComplaintStatus.escalatedToHod:
        return 'Escalated to HOD';
      case ComplaintStatus.resolved:
        return 'Resolved';
      case ComplaintStatus.rejected:
        return 'Rejected';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
} 