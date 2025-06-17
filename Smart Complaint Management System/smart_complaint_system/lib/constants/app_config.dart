class AppConfig {
  // Supabase Configuration
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // App Configuration
  static const String appName = 'Smart Complaint System';
  static const String appVersion = '1.0.0';

  // Storage Buckets
  static const String complaintImagesBucket = 'complaint-images';
  static const String complaintVideosBucket = 'complaint-videos';

  // Database Tables
  static const String usersTable = 'users';
  static const String complaintsTable = 'complaints';
  static const String commentsTable = 'complaint_comments';
  static const String departmentsTable = 'departments';
  static const String batchesTable = 'batches';

  // Status Messages
  static const String loadingMessage = 'Please wait...';
  static const String errorMessage = 'Something went wrong. Please try again.';
  static const String successMessage = 'Operation completed successfully.';

  // Validation Messages
  static const String requiredFieldMessage = 'This field is required';
  static const String invalidEmailMessage = 'Please enter a valid email address';
  static const String invalidPasswordMessage = 'Password must be at least 6 characters';
} 