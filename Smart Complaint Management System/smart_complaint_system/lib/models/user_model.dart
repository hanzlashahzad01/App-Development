enum UserRole { admin, hod, batchAdvisor, student }

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? department;
  final String? batch;
  final String? batchAdvisorEmail;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.department,
    this.batch,
    this.batchAdvisorEmail,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['full_name'] as String,
      email: json['email'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == (json['role'] as String).toLowerCase(),
        orElse: () => UserRole.student, // Default to student if role not found or null
      ),
      department: json['department'] as String?,
      batch: json['batch'] as String?,
      batchAdvisorEmail: json['batch_advisor_email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.toString().split('.').last,
      'department': department,
      'batch': batch,
      'batch_advisor_email': batchAdvisorEmail,
    };
  }
} 