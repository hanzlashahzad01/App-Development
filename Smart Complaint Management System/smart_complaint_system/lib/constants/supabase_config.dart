class SupabaseConfig {
  // Replace these with your actual Supabase project credentials
  static const String projectUrl = 'https://your-project-id.supabase.co';
  static const String anonKey = 'your-anon-key';
  
  // Table names
  static const String usersTable = 'users';
  static const String complaintsTable = 'complaints';
  static const String complaintCommentsTable = 'complaint_comments';
  
  // Storage bucket names
  static const String mediaBucket = 'media';
} 