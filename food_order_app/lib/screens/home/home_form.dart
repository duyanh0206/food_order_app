import 'package:flutter/material.dart';
import 'package:food_order_app/db/database_helper.dart';
import 'package:food_order_app/screens/search/search_screen.dart';

import 'food_menu_tabs.dart';
import 'onboarding_banner.dart';

class HomeForm extends StatefulWidget {
  const HomeForm({super.key});

  @override
  State<HomeForm> createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  String _userName = '';
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hello message
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                          'Hello, $_userName!',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
              ),
              // Craving message
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: const Text(
                  'What are you craving?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GestureDetector(
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchScreen(),
                        ),
                      ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey.shade600),
                        const SizedBox(width: 12),
                        Text(
                          'search...',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Onboarding Banner Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: OnboardingBanner(),
              ),
              const SizedBox(height: 16),
              // Food Menu Tabs Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: FoodMenuTabs(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
