import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static const String _currentUserKey = 'current_user_id';
  static SharedPreferences? _prefs;

  DatabaseHelper._init();

  // Initialize SharedPreferences
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
    
    // Debug database path
    debugPrint('Database path: $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onOpen: (db) async {
        // Debug table structure
        final tables = await db.query('sqlite_master', where: 'type = ?', whereArgs: ['table']);
        debugPrint('Database tables: ${tables.map((t) => t['name']).toList()}');
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
    debugPrint('Database tables created');
  }

  Future<int> createUser(UserModel user) async {
    final db = await database;
    try {
      final userData = user.toMap();
      userData['email'] = userData['email'].toLowerCase();
      
      debugPrint('Creating user with data: $userData');
      
      final id = await db.insert(
        'users',
        userData,
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      
      // Verify user was created
      final createdUser = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
      
      debugPrint('Created user data: ${createdUser.first}');
      
      await setCurrentUserId(id);
      return id;
    } catch (e) {
      debugPrint('Error creating user: $e');
      rethrow;
    }
  }

  Future<UserModel?> getUser(String email, String password) async {
    final db = await database;
    try {
      debugPrint('Attempting login with email: $email');
      
      // Debug: List all users
      final allUsers = await db.query('users');
      debugPrint('All users in database: ${allUsers.length}');
      
      final List<Map<String, dynamic>> users = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email.toLowerCase(), password],
      );

      if (users.isNotEmpty) {
        final user = UserModel.fromMap(users.first);
        debugPrint('Found user: ${user.name}');
        await setCurrentUserId(user.id!);
        return user;
      }
      
      debugPrint('No user found for email: $email');
      return null;
    } catch (e) {
      debugPrint('Login error: $e');
      return null;
    }
  }

  // Update setCurrentUserId method
  Future<bool> setCurrentUserId(int userId) async {
    try {
      final preferences = await prefs;
      final result = await preferences.setInt(_currentUserKey, userId);
      debugPrint('Set current user ID: $userId, success: $result');
      return result;
    } catch (e) {
      debugPrint('Error setting current user ID: $e');
      return false;
    }
  }

  // Update getCurrentUser method
  Future<UserModel?> getCurrentUser() async {
    try {
      final preferences = await prefs;
      final userId = preferences.getInt(_currentUserKey);
      debugPrint('Got current user ID: $userId');
      
      if (userId == null) {
        debugPrint('No current user ID found');
        return null;
      }

      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        debugPrint('Found user data for ID: $userId');
        return UserModel.fromMap(maps.first);
      }
      
      debugPrint('No user found for ID: $userId');
      return null;
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  // Update clearCurrentUser method
  Future<bool> clearCurrentUser() async {
    try {
      final preferences = await prefs;
      final result = await preferences.remove(_currentUserKey);
      debugPrint('Cleared current user, success: $result');
      return result;
    } catch (e) {
      debugPrint('Error clearing current user: $e');
      return false;
    }
  }

  Future<void> close() async {
    if (_database != null) {
      final db = await database;
      await db.close();
      _database = null;
    }
  }
}