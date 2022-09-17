import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/measure_model.dart';

const String databaseName = "hole.db";

class HoleDatabaseService {
  init() async {
    await _createTable();
  }

  Future<Database> _getDatabase() async {
    String databasesPath = await getDatabasesPath() + databaseName;
    Database database = await openDatabase(databasesPath);
    return database;
  }

  ///删除数据库
  Future<void> _deleteDatabase() async {
    String databasesPath = await getDatabasesPath() + databaseName;
    await deleteDatabase(databasesPath);
  }

  ///创建user_info的表
  Future<void> _createTable() async {
    Database database = await _getDatabase();
    database.execute(
        'CREATE TABLE hole_info (id INTEGER PRIMARY KEY, noM INTEGER, name TEXT, restForTop REAL, sideBet REAL, holeWidth REAL, dateTime TEXT)');
  }

  ///删除user_info表
  Future<void> deleteTable() async {
    Database database = await _getDatabase();
    database.execute('DROP TABLE hole_info');
  }

  ///查询表中全部数据
  Future<void> _selectAllRow() async {
    Database database = await _getDatabase();
    List<Map> list = await database.rawQuery('SELECT * FROM hole_info');
    //上面这条语句等价于下面这条语句
    //List<Map> list =await database.query("user_info");
    if (kDebugMode) {
      print("查询表中全部数据");
      print(list);
    }
  }

  ///向表中增加一条数据，其中id（主键）自生成，name为徐晖
  Future<void> addRow(int noM, String name, double holeWidth, double restForTop,
      double sideBet, String datetime) async {
    Database database = await _getDatabase();
    int id = await database.rawInsert(
        'INSERT INTO hole_info(noM,name,restForTop,sideBet,holeWidth,dateTime) VALUES("$noM","$name","$restForTop","$sideBet","$holeWidth","$datetime")');
    //上面这条语句等价于下面这条语句
    //int id=await database.insert("user_info", {'name': '徐晖'});
    if (kDebugMode) {
      print('新插入的数据的ID是：$id');
    }
  }

  ///删除表中所有记录
  Future<void> _deleteAllRow() async {
    Database database = await _getDatabase();
    int count = await database.rawDelete('DELETE FROM hole_info');
    //上面这条语句等价于下面这条语句
    //int count=await database.delete("user_info");

    if (kDebugMode) {
      print('删除表中所有记录，共删除$count条记录');
    }
  }

  ///删除表中所有name字段为徐晖的记录
  Future<void> deleteRow(int id) async {
    Database database = await _getDatabase();
    int count =
        await database.rawDelete('DELETE FROM hole_info WHERE id = ?', [id]);
    //上面这条语句等价于下面这条语句
    //int count=await database.delete("user_info",where: 'name = ?', whereArgs: ['徐晖']);

    if (kDebugMode) {
      print('删除表中所有name字段为徐晖的记录，共删除$count条记录');
    }
  }

  ///将表中所有name字段为徐晖的记录的name字段值改成王克鸿
  Future<void> _updateRow() async {
    Database database = await _getDatabase();
    int count = await database.rawUpdate(
        "UPDATE hole_info SET name = ? WHERE name = ?", ['王克鸿', '徐晖']);
    //上面这条语句等价于下面这条语句
    //int count=await database.update("user_info", {'name': '王克鸿'}, where: 'name = ?', whereArgs: ['徐晖']);

    if (kDebugMode) {
      print('将表中所有name字段为徐晖的记录的name字段值改成王克鸿，共修改$count条记录');
    }
  }

  Future<List<HoleModel>> queryHoles() async {
    Database database = await _getDatabase();
    List<Map<String, dynamic>> maps = await database.query('hole_info');
    return List.generate(maps.length, (i) {
      return HoleModel(
          name: maps[i]['name'],
          dateTime: maps[i]['dateTime'],
          id: maps[i]['id'],
          restForTop: maps[i]['restForTop'],
          sideBet: maps[i]['sideBet'],
          holeWidth: maps[i]['holeWidth'],
          noM: maps[i]['noM']);
    }).reversed.toList();
  }

  ///查询表中所有name字段的值为徐晖的数据
  Future<List<HoleModel>> selectRow(int group) async {
    Database database = await _getDatabase();
    List<Map> list = await database
        .rawQuery('SELECT * FROM hole_info WHERE nom = ?', [group]);
    //上面这条语句等价于下面这条语句
    // List<Map> list =await database.query("user_info", where: 'name = ?', whereArgs: ['徐晖']);
    if (kDebugMode) {
      print('查询表中所有name字段的值为徐晖的数据');
      print(list);
    }
    return List.generate(list.length, (i) {
      return HoleModel(
          name: list[i]['name'],
          dateTime: list[i]['dateTime'],
          id: list[i]['id'],
          restForTop: list[i]['restForTop'],
          sideBet: list[i]['sideBet'],
          holeWidth: list[i]['holeWidth'],
          noM: list[i]['noM']);
    }).reversed.toList();
  }
}
