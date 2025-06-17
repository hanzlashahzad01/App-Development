import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/supabase_config.dart';

class TestConnection {
  final _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> testConnection() async {
    try {
      // Test 1: Check if Supabase is initialized
      if (!Supabase.instance.client.auth.currentSession.isExpired) {
        print('✅ Supabase is initialized');
      } else {
        print('❌ Supabase is not initialized');
      }

      // Test 2: Check if tables exist
      final tables = await _supabase.from('users').select('count').limit(1);
      print('✅ Users table exists');

      final complaints = await _supabase.from('complaints').select('count').limit(1);
      print('✅ Complaints table exists');

      final comments = await _supabase.from('complaint_comments').select('count').limit(1);
      print('✅ Comments table exists');

      // Test 3: Check storage bucket
      final buckets = await _supabase.storage.listBuckets();
      final mediaBucket = buckets.firstWhere(
        (bucket) => bucket.name == SupabaseConfig.mediaBucket,
        orElse: () => throw Exception('Media bucket not found'),
      );
      print('✅ Media bucket exists');

      return {
        'status': 'success',
        'message': 'All connections are working properly',
        'details': {
          'supabase_initialized': true,
          'tables_exist': true,
          'storage_bucket_exists': true,
        }
      };
    } catch (e) {
      print('❌ Error testing connection: $e');
      return {
        'status': 'error',
        'message': e.toString(),
        'details': {
          'supabase_initialized': false,
          'tables_exist': false,
          'storage_bucket_exists': false,
        }
      };
    }
  }

  Future<void> testAuth() async {
    try {
      // Test 1: Sign up
      final signUpResponse = await _supabase.auth.signUp(
        email: 'test@example.com',
        password: 'test123456',
      );
      print('✅ Sign up successful');

      // Test 2: Sign in
      final signInResponse = await _supabase.auth.signInWithPassword(
        email: 'test@example.com',
        password: 'test123456',
      );
      print('✅ Sign in successful');

      // Test 3: Get current user
      final user = _supabase.auth.currentUser;
      print('✅ Current user: ${user?.email}');

      // Test 4: Sign out
      await _supabase.auth.signOut();
      print('✅ Sign out successful');

    } catch (e) {
      print('❌ Error testing auth: $e');
    }
  }

  Future<void> testDatabase() async {
    try {
      // Test 1: Create a test user
      final userResponse = await _supabase.from('users').insert({
        'email': 'test@example.com',
        'full_name': 'Test User',
        'role': 'student',
        'batch': '2023',
        'department': 'Computer Science',
      }).select();
      print('✅ User created successfully');

      // Test 2: Create a test complaint
      final complaintResponse = await _supabase.from('complaints').insert({
        'student_id': userResponse[0]['id'],
        'student_name': 'Test User',
        'title': 'Test Complaint',
        'description': 'This is a test complaint',
        'status': 'submitted',
        'priority': 'medium',
      }).select();
      print('✅ Complaint created successfully');

      // Test 3: Create a test comment
      final commentResponse = await _supabase.from('complaint_comments').insert({
        'complaint_id': complaintResponse[0]['id'],
        'user_id': userResponse[0]['id'],
        'user_name': 'Test User',
        'user_role': 'student',
        'comment': 'This is a test comment',
      }).select();
      print('✅ Comment created successfully');

      // Test 4: Clean up test data
      await _supabase.from('complaint_comments').delete().eq('id', commentResponse[0]['id']);
      await _supabase.from('complaints').delete().eq('id', complaintResponse[0]['id']);
      await _supabase.from('users').delete().eq('id', userResponse[0]['id']);
      print('✅ Test data cleaned up successfully');

    } catch (e) {
      print('❌ Error testing database: $e');
    }
  }
} 