import 'package:flutter/material.dart';

enum ComplaintStatus {
  submitted,
  inProgress,
  escalatedToHod,
  resolved,
  rejected,
}

enum ComplaintPriority {
  low,
  medium,
  high,
}

class ComplaintModel {
  final String id;
  final String studentId;
  final String studentName;
  final String title;
  final String description;
  final ComplaintStatus status;
  final ComplaintPriority priority;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? imageUrl;
  final String? videoUrl;
  final String? currentHandlerId;
  final String? currentHandlerName;
  final String? currentHandlerRole;
  final String? resolution;
  final DateTime? resolvedAt;
  final List<ComplaintComment> comments;

  ComplaintModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.updatedAt,
    this.imageUrl,
    this.videoUrl,
    this.currentHandlerId,
    this.currentHandlerName,
    this.currentHandlerRole,
    this.resolution,
    this.resolvedAt,
    required this.comments,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      studentName: json['student_name'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: ComplaintStatus.values.firstWhere(
        (e) => e.toString() == 'ComplaintStatus.${json['status']}',
      ),
      priority: ComplaintPriority.values.firstWhere(
        (e) => e.toString() == 'ComplaintPriority.${json['priority']}',
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      imageUrl: json['image_url'] as String?,
      videoUrl: json['video_url'] as String?,
      currentHandlerId: json['current_handler_id'] as String?,
      currentHandlerName: json['current_handler_name'] as String?,
      currentHandlerRole: json['current_handler_role'] as String?,
      resolution: json['resolution'] as String?,
      resolvedAt: json['resolved_at'] != null
          ? DateTime.parse(json['resolved_at'] as String)
          : null,
      comments: (json['comments'] as List<dynamic>)
          .map((e) => ComplaintComment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'student_name': studentName,
      'title': title,
      'description': description,
      'status': status.toString().split('.').last,
      'priority': priority.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'image_url': imageUrl,
      'video_url': videoUrl,
      'current_handler_id': currentHandlerId,
      'current_handler_name': currentHandlerName,
      'current_handler_role': currentHandlerRole,
      'resolution': resolution,
      'resolved_at': resolvedAt?.toIso8601String(),
      'comments': comments.map((e) => e.toJson()).toList(),
    };
  }

  ComplaintModel copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? title,
    String? description,
    ComplaintStatus? status,
    ComplaintPriority? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? imageUrl,
    String? videoUrl,
    String? currentHandlerId,
    String? currentHandlerName,
    String? currentHandlerRole,
    String? resolution,
    DateTime? resolvedAt,
    List<ComplaintComment>? comments,
  }) {
    return ComplaintModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      currentHandlerId: currentHandlerId ?? this.currentHandlerId,
      currentHandlerName: currentHandlerName ?? this.currentHandlerName,
      currentHandlerRole: currentHandlerRole ?? this.currentHandlerRole,
      resolution: resolution ?? this.resolution,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      comments: comments ?? this.comments,
    );
  }
}

class ComplaintComment {
  final String id;
  final String userId;
  final String userName;
  final String comment;
  final DateTime createdAt;
  final String userRole;

  ComplaintComment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.createdAt,
    required this.userRole,
  });

  factory ComplaintComment.fromJson(Map<String, dynamic> json) {
    return ComplaintComment(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      userRole: json['user_role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'user_role': userRole,
    };
  }
} 