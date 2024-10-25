import 'package:sqflite/sqflite.dart';
import '../../models/voter.dart';
import 'database_helper.dart';

class VoterService {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insert(Voter voter) async {
    Database db = await dbHelper.database;
    return await db.insert(DatabaseHelper.table, voter.toMap());
  }

  Future<List<Voter>> getAllVoters() async {
    try {
      final db = await dbHelper.database;
      final List<Map<String, dynamic>> maps =
          await db.query(DatabaseHelper.table);
      return List.generate(maps.length, (i) {
        return Voter.fromMap(maps[i]);
      });
    } catch (e) {
      print('Error getting all voters: $e');
      return [];
    }
  }

  Future<int> update(Voter voter) async {
    Database db = await dbHelper.database;
    return await db.update(
      DatabaseHelper.table,
      voter.toMap(),
      where: '${DatabaseHelper.columnId} = ?',
      whereArgs: [voter.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      DatabaseHelper.table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
