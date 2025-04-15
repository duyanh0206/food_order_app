import 'package:flutter/material.dart';
import 'package:food_order_app/db/database_helper.dart';

class HomeForm extends StatefulWidget {  // Changed from HomePage to HomeForm
  const HomeForm({super.key});

  @override
  State<HomeForm> createState() => _HomeFormState();  // Changed to _HomeFormState
}

class _HomeFormState extends State<HomeForm> {  // Changed from _HomePageState
  String _userName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final user = await DatabaseHelper.instance.getCurrentUser();
      if (mounted) {
        setState(() {
          _userName = user?.name ?? 'Guest';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading user name: $e');
      if (mounted) {
        setState(() {
          _userName = 'Guest';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with user name
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _isLoading 
              ? const CircularProgressIndicator()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, $_userName!',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
          ),
          // Content area
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Add your content here
                    const Text('Welcome to Food Order App'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}