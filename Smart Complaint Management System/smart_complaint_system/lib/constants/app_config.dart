class AppConfig {
  // Supabase Configuration
  static const String supabaseUrl = 'https://cfpzmtdpqnbqudtefzrb.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNmcHptdGRwcW5icXVkdGVmenJiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk5ODY4NjIsImV4cCI6MjA2NTU2Mjg2Mn0.oCtrYcRaeeHsTS7L49PNk-iq55h_gc1cLYVjl_paLbU';

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