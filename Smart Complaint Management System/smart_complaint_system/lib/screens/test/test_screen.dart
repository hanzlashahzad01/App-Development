import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';
import '../../services/test_connection.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final _testConnection = TestConnection();
  Map<String, dynamic>? _connectionResult;
  bool _isLoading = false;
  String? _error;

  Future<void> _runTests() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Test connection
      final result = await _testConnection.testConnection();
      setState(() {
        _connectionResult = result;
      });

      if (result['status'] == 'success') {
        // Test auth
        await _testConnection.testAuth();
        
        // Test database
        await _testConnection.testDatabase();
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connection Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _runTests,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Run Tests'),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _error!,
                  style: TextStyle(color: AppTheme.errorColor),
                ),
              ),
            if (_connectionResult != null) ...[
              const SizedBox(height: 16),
              Text(
                'Connection Status: ${_connectionResult!['status']}',
                style: AppTheme.subheadingStyle,
              ),
              const SizedBox(height: 8),
              Text(
                _connectionResult!['message'],
                style: AppTheme.bodyStyle,
              ),
              const SizedBox(height: 16),
              const Text(
                'Details:',
                style: AppTheme.subheadingStyle,
              ),
              const SizedBox(height: 8),
              ...(_connectionResult!['details'] as Map<String, dynamic>).entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        entry.value ? Icons.check_circle : Icons.error,
                        color: entry.value
                            ? AppTheme.successColor
                            : AppTheme.errorColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${entry.key}: ${entry.value ? 'Success' : 'Failed'}',
                        style: AppTheme.bodyStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 