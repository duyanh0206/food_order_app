import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static const String _currentUserKey = 'current_user_id';
  static SharedPreferences? _prefs;

  DatabaseHelper._init();

  // Get SharedPreferences instance
  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'food_order.db');

    debugPrint('[DB] Database path: $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onOpen: (db) async {
        final tables = await db.query(
          'sqlite_master',
          where: 'type = ?',
          whereArgs: ['table'],
        );
        debugPrint('[DB] Tables: ${tables.map((t) => t['name']).toList()}');
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    debugPrint('[DB] Table `users` created');
  }

  // Create a new user
  Future<int> createUser(UserModel user) async {
    final db = await database;
    try {
      final userData = user.toMap();
      userData['email'] = userData['email'].toLowerCase();
      debugPrint('[DB] Creating user: $userData');

      final id = await db.insert(
        'users',
        userData,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );

      final createdUser = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
      debugPrint('[DB] Created user data: ${createdUser.first}');

      await setCurrentUserId(id); // Set current user after creation
      return id;
    } catch (e) {
      debugPrint('[DB] Error creating user: $e');
      rethrow;
    }
  }

  // Login - get user by email & password
  Future<UserModel?> getUser(String email, String password) async {
    final db = await database;
    try {
      final emailLower = email.toLowerCase();
      debugPrint('[DB] Attempt login: email=$emailLower');

      final List<Map<String, dynamic>> users = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [emailLower, password],
      );

      if (users.isNotEmpty) {
        final user = UserModel.fromMap(users.first);
        debugPrint('[DB] Login successful: ${user.name}');
        await setCurrentUserId(user.id!); // Save current user
        return user;
      } else {
        debugPrint('[DB] No matching user found for email: $emailLower');
        return null;
      }
    } catch (e) {
      debugPrint('[DB] Login error: $e');
      return null;
    }
  }

  // Save current user ID to SharedPreferences
  Future<bool> setCurrentUserId(int userId) async {
    try {
      final preferences = await prefs;
      final result = await preferences.setInt(_currentUserKey, userId);
      debugPrint(
        '[SharedPrefs] Set current user ID: $userId, success: $result',
      );
      return result;
    } catch (e) {
      debugPrint('[SharedPrefs] Error setting current user ID: $e');
      return false;
    }
  }

  // Get current logged-in user
  Future<UserModel?> getCurrentUser() async {
    try {
      final preferences = await prefs;
      final userId = preferences.getInt(_currentUserKey);
      debugPrint('[SharedPrefs] Retrieved current user ID: $userId');

      if (userId == null) {
        debugPrint('[SharedPrefs] No user ID found in prefs');
        return null;
      }

      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
        limit: 1,
      );

      debugPrint('[DB] Query result: $maps');

      if (maps.isNotEmpty) {
        final user = UserModel.fromMap(maps.first);
        debugPrint('[DB] Found current user: ${user.name} (${user.email})');
        return user;
      } else {
        debugPrint('[DB] No user found with ID: $userId');
        return null;
      }
    } catch (e) {
      debugPrint('[DB] Error getting current user: $e');
      return null;
    }
  }

  // Clear current user info
  Future<bool> clearCurrentUser() async {
    try {
      final preferences = await prefs;
      final result = await preferences.remove(_currentUserKey);
      debugPrint('[SharedPrefs] Cleared current user ID, success: $result');
      return result;
    } catch (e) {
      debugPrint('[SharedPrefs] Error clearing current user: $e');
      return false;
    }
  }

  Future<void> close() async {
    if (_database != null) {
      final db = await database;
      await db.close();
      _database = null;
      debugPrint('[DB] Database closed');
    }
  }
}
