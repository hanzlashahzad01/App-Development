import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../constants/app_config.dart';

class AuthProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  Future<void> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _fetchUserData(response.user!.id);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Create user profile in the users table
        await _supabase.from(AppConfig.usersTable).insert({
          'id': response.user!.id,
          'email': email,
          'full_name': name,
          'role': 'student', // Default role
        });

        await _fetchUserData(response.user!.id);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _supabase.auth.signOut();
      _currentUser = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchUserData(String userId) async {
    try {
      final response = await _supabase
          .from(AppConfig.usersTable)
          .select()
          .eq('id', userId)
          .single();

      _currentUser = UserModel.fromJson(response);
    } catch (e) {
      _error = e.toString();
      _currentUser = null;
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _supabase
          .from(AppConfig.usersTable)
          .update(data)
          .eq('id', _currentUser!.id);

      await _fetchUserData(_currentUser!.id);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 