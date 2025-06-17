import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_config.dart';
import '../models/complaint_model.dart';

class ComplaintService {
  final _supabase = Supabase.instance.client;

  Future<void> submitComplaint(ComplaintModel complaint) async {
    await _supabase.from(AppConfig.complaintsTable).insert(complaint.toJson());
  }

  Future<List<ComplaintModel>> getStudentComplaints(String studentId) async {
    final response = await _supabase
        .from(AppConfig.complaintsTable)
        .select()
        .eq('student_id', studentId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => ComplaintModel.fromJson(json))
        .toList();
  }

  Future<List<ComplaintModel>> getBatchAdvisorComplaints(
    String batchAdvisorEmail,
  ) async {
    final response = await _supabase
        .from(AppConfig.complaintsTable)
        .select()
        .eq('batch_advisor_email', batchAdvisorEmail)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => ComplaintModel.fromJson(json))
        .toList();
  }

  Future<List<ComplaintModel>> getHodComplaints(String department) async {
    final response = await _supabase
        .from(AppConfig.complaintsTable)
        .select()
        .eq('department', department)
        .eq('status', ComplaintStatus.escalatedToHod.toString().split('.').last)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => ComplaintModel.fromJson(json))
        .toList();
  }

  Future<void> updateComplaintStatus(
    String complaintId,
    ComplaintStatus status,
    String? handlerId,
    String? handlerName,
  ) async {
    await _supabase.from(AppConfig.complaintsTable).update({
      'status': status.toString().split('.').last,
      'current_handler_id': handlerId,
      'current_handler_name': handlerName,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', complaintId);
  }

  Future<void> addComment(
    String complaintId,
    ComplaintComment comment,
  ) async {
    await _supabase.from(AppConfig.commentsTable).insert({
      ...comment.toJson(),
      'complaint_id': complaintId,
    });
  }

  Future<List<ComplaintComment>> getComplaintComments(String complaintId) async {
    final response = await _supabase
        .from(AppConfig.commentsTable)
        .select()
        .eq('complaint_id', complaintId)
        .order('created_at', ascending: true);

    return (response as List)
        .map((json) => ComplaintComment.fromJson(json))
        .toList();
  }

  Future<Map<String, dynamic>> getComplaintStats(String userId, String role) async {
    final query = _supabase.from(AppConfig.complaintsTable).select();

    switch (role) {
      case 'student':
        query.eq('student_id', userId);
        break;
      case 'batch_advisor':
        query.eq('batch_advisor_email', userId);
        break;
      case 'hod':
        query.eq('department', userId);
        break;
      default:
        throw Exception('Invalid role');
    }

    final response = await query;
    final complaints = (response as List)
        .map((json) => ComplaintModel.fromJson(json))
        .toList();

    return {
      'total': complaints.length,
      'submitted': complaints
          .where((c) => c.status == ComplaintStatus.submitted)
          .length,
      'inProgress': complaints
          .where((c) => c.status == ComplaintStatus.inProgress)
          .length,
      'escalated': complaints
          .where((c) => c.status == ComplaintStatus.escalatedToHod)
          .length,
      'resolved': complaints
          .where((c) => c.status == ComplaintStatus.resolved)
          .length,
      'rejected': complaints
          .where((c) => c.status == ComplaintStatus.rejected)
          .length,
    };
  }

  Future<List<ComplaintModel>> getComplaints() async {
    try {
      final response = await _supabase
          .from('complaints')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => ComplaintModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch complaints: $e');
    }
  }

  Future<ComplaintModel> getComplaint(String id) async {
    try {
      final response = await _supabase
          .from('complaints')
          .select()
          .eq('id', id)
          .single();

      return ComplaintModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch complaint: $e');
    }
  }

  Future<ComplaintModel> createComplaint(ComplaintModel complaint) async {
    try {
      final response = await _supabase
          .from('complaints')
          .insert(complaint.toJson())
          .select()
          .single();

      return ComplaintModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create complaint: $e');
    }
  }

  Future<ComplaintModel> updateComplaint(ComplaintModel complaint) async {
    try {
      final response = await _supabase
          .from('complaints')
          .update(complaint.toJson())
          .eq('id', complaint.id)
          .select()
          .single();

      return ComplaintModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update complaint: $e');
    }
  }

  Future<void> deleteComplaint(String id) async {
    try {
      await _supabase.from('complaints').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete complaint: $e');
    }
  }

  Future<String> uploadMedia(File file, String complaintId) async {
    try {
      final fileExt = file.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = 'complaints/$complaintId/$fileName';

      await _supabase.storage.from('media').upload(filePath, file);
      final fileUrl = _supabase.storage.from('media').getPublicUrl(filePath);

      return fileUrl;
    } catch (e) {
      throw Exception('Failed to upload media: $e');
    }
  }

  Future<List<ComplaintComment>> getComplaintComments(String complaintId) async {
    try {
      final response = await _supabase
          .from('complaint_comments')
          .select()
          .eq('complaint_id', complaintId)
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) => ComplaintComment.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch comments: $e');
    }
  }

  Future<ComplaintComment> addComment(String complaintId, ComplaintComment comment) async {
    try {
      final commentData = {
        ...comment.toJson(),
        'complaint_id': complaintId,
      };

      final response = await _supabase
          .from('complaint_comments')
          .insert(commentData)
          .select()
          .single();

      return ComplaintComment.fromJson(response);
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  Future<void> deleteComment(String commentId) async {
    try {
      await _supabase.from('complaint_comments').delete().eq('id', commentId);
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }
} 