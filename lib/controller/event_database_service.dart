import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/measure_model.dart';

const String databaseName = "event.db";

class EventDatabaseService {
  init() async {
    await _getDatabase();
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
  Future<void> createTable() async {
    Database database = await _getDatabase();
    database.execute(
        'CREATE TABLE event_info (id INTEGER PRIMARY KEY, name TEXT, describe TEXT, dateTime TEXT)');
  }

  ///删除user_info表
  Future<void> deleteTable() async {
    Database database = await _getDatabase();
    database.execute('DROP TABLE event_info');
  }

  ///查询表中全部数据
  Future<void> _selectAllRow() async {
    Database database = await _getDatabase();
    List<Map> list = await database.rawQuery('SELECT * FROM event_info');
    //上面这条语句等价于下面这条语句
    //List<Map> list =await database.query("user_info");
    if (kDebugMode) {
      print("查询表中全部数据");
      print(list);
    }
  }

  ///查询表中所有name字段的值为徐晖的数据
  Future<void> _selectRow() async {
    Database database = await _getDatabase();
    List<Map> list = await database
        .rawQuery('SELECT * FROM event_info WHERE name = ?', ['徐晖']);
    //上面这条语句等价于下面这条语句
    //List<Map> list =await database.query("user_info", where: 'name = ?', whereArgs: ['徐晖']);
    if (kDebugMode) {
      print('查询表中所有name字段的值为徐晖的数据');
      print(list);
    }
  }

  ///向表中增加一条数据，其中id（主键）自生成，name为徐晖
  Future<void> addRow(String name, String describe, String datetime) async {
    Database database = await _getDatabase();
    int id = await database.rawInsert(
        'INSERT INTO event_info(name,describe,dateTime) VALUES("$name","$describe","$datetime")');
    //上面这条语句等价于下面这条语句
    //int id=await database.insert("user_info", {'name': '徐晖'});
    if (kDebugMode) {
      print('新插入的数据的ID是：$id');
    }
  }

  ///删除表中所有记录
  Future<void> _deleteAllRow() async {
    Database database = await _getDatabase();
    int count = await database.rawDelete('DELETE FROM event_info');
    //上面这条语句等价于下面这条语句
    //int count=await database.delete("user_info");

    if (kDebugMode) {
      print('删除表中所有记录，共删除$count条记录');
    }
  }

  ///删除表中所有name字段为徐晖的记录
  Future<void> _deleteRow() async {
    Database database = await _getDatabase();
    int count = await database
        .rawDelete('DELETE FROM event_info WHERE name = ?', ['徐晖']);
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
        "UPDATE event_info SET name = ? WHERE name = ?", ['王克鸿', '徐晖']);
    //上面这条语句等价于下面这条语句
    //int count=await database.update("user_info", {'name': '王克鸿'}, where: 'name = ?', whereArgs: ['徐晖']);

    if (kDebugMode) {
      print('将表中所有name字段为徐晖的记录的name字段值改成王克鸿，共修改$count条记录');
    }
  }

  Future<List<EventModel>> queryEvents() async {
    Database database = await _getDatabase();
    List<Map<String, dynamic>> maps = await database.query('event_info');
    return List.generate(maps.length, (i) {
      return EventModel(
          name: maps[i]['name'],
          dateTime: maps[i]['dateTime'],
          id: maps[i]['id'],
          describe: maps[i]['describe']);
    }).reversed.toList();
  }
}
