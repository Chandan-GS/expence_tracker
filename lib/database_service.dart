import 'package:flutter/foundation.dart' as flutter;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'models/expence_data.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;
  DatabaseService._init();

  void setDatabase(Database db) {
    _database = db;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expense_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      return await openDatabase(
        path,
        version: 1,
        onCreate: createTables,
        onConfigure: _onConfigure,
      );
    } catch (e) {
      flutter.debugPrint('Database initialization error: $e');
      rethrow;
    }
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> createTables(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE users (
          user_id TEXT PRIMARY KEY,
          username TEXT UNIQUE NOT NULL,
          email TEXT UNIQUE NOT NULL,
          password_hash TEXT NOT NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      ''');

      await db.execute('''
        CREATE TABLE expenses (
          expense_id TEXT PRIMARY KEY,
          user_id TEXT NOT NULL,
          title TEXT NOT NULL,
          amount REAL NOT NULL,
          category TEXT NOT NULL,
          date TEXT NOT NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
        )
      ''');
    } catch (e) {
      flutter.debugPrint('Error creating tables: $e');
      rethrow;
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  Future<String?> registerUser(
      String name, String email, String password) async {
    final db = await database;
    try {
      return await db.transaction((txn) async {
        final existingUser = await txn.query(
          'users',
          where: 'email = ?',
          whereArgs: [email],
        );

        if (existingUser.isNotEmpty) {
          return null;
        }

        final userId = const Uuid().v4();
        final hashedPassword = _hashPassword(password);

        await txn.insert('users', {
          'user_id': userId,
          'username': name,
          'email': email,
          'password_hash': hashedPassword,
        });

        return userId;
      });
    } catch (e) {
      flutter.debugPrint('Registration error: $e');
      return null;
    }
  }

  Future<String?> loginUser(String email, String password) async {
    try {
      final db = await database;
      final hashedPassword = _hashPassword(password);

      final result = await db.query(
        'users',
        columns: ['user_id'],
        where: 'email = ? AND password_hash = ?',
        whereArgs: [email, hashedPassword],
      );

      return result.isEmpty ? null : result.first['user_id'] as String;
    } catch (e) {
      flutter.debugPrint('Login error: $e');
      return null;
    }
  }

  Future<void> addExpense(String userId, ExpenceData expense) async {
    try {
      final db = await database;
      await db.insert('expenses', {
        'expense_id': expense.id, // Use the ID from ExpenceData
        'user_id': userId,
        'title': expense.title,
        'amount': expense.amount,
        'category': expense.category.toString().split('.').last,
        'date': expense.date.toIso8601String(),
      });
    } catch (e) {
      flutter.debugPrint('Add expense error: $e');
      rethrow;
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      final db = await database;
      final deletedCount = await db.delete(
        'expenses',
        where: 'expense_id = ?',
        whereArgs: [expenseId],
      );
      flutter.debugPrint(
          'Deleted $deletedCount expense(s) with ID: $expenseId'); // Add debug log
    } catch (e) {
      flutter.debugPrint('Delete expense error: $e');
      rethrow;
    }
  }

  Future<void> deleteUserAccount(String userId) async {
    try {
      final db = await database;
      await db.delete(
        'users',
        where: 'user_id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      flutter.debugPrint('Delete user error: $e');
      rethrow;
    }
  }

  Future<List<ExpenceData>> getUserExpenses(String userId) async {
    try {
      final db = await database;
      final expenses = await db.query(
        'expenses',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'date DESC',
      );

      return expenses
          .map((row) => ExpenceData(
                id: row['expense_id']
                    as String, // Include the ID when creating ExpenceData
                title: row['title'] as String,
                amount: (row['amount'] as num).toDouble(),
                category: Category.values.firstWhere(
                    (c) => c.toString().split('.').last == row['category']),
                date: DateTime.parse(row['date'] as String),
              ))
          .toList();
    } catch (e) {
      flutter.debugPrint('Get expenses error: $e');
      return [];
    }
  }
}
