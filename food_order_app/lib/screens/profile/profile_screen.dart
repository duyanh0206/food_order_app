import 'package:flutter/material.dart';

// Nếu đang dùng Theme toàn app từ bên ngoài, thì truyền vào qua ValueNotifier
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
        actions: [
          // Kéo ngang icon hoặc bấm sẽ đổi theme
          GestureDetector(
            onHorizontalDragEnd: (_) {
              themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
            },
            child: IconButton(
              icon: Icon(isDark ? Icons.wb_sunny : Icons.nightlight_round),
              onPressed: () {
                themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Current Theme: ${isDark ? "Dark" : "Light"}',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
