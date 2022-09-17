import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/measure_model.dart';

const String databaseName = "measure.db";

class MeasureDatabaseService {
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
        'CREATE TABLE measure_info (id INTEGER PRIMARY KEY, noM INTEGER, x REAL, y REAL, fx REAL, fy REAL, tmp REAL, dateTime TEXT, depth REAL, isDouble INTEGER)');
  }

  ///删除user_info表
  Future<void> deleteTable() async {
    Database database = await _getDatabase();
    database.execute('DROP TABLE measure_info');
  }

  ///查询表中全部数据
  Future<void> selectAllRow() async {
    print('123');
    Database database = await _getDatabase();
    List<Map> list = await database.rawQuery('SELECT * FROM measure_info');
    //上面这条语句等价于下面这条语句
    //List<Map> list =await database.query("user_info");
    if (kDebugMode) {
      print("查询表中全部数据");
      print(list);
    }
  }

  ///向表中增加一条数据，其中id（主键）自生成，name为徐晖
  Future<void> addRow(int noM, double x, double y, double fx, double fy,
      double tmp, double depth, String datetime, int isDouble) async {
    Database database = await _getDatabase();
    int id = await database.rawInsert(
        'INSERT INTO measure_info(nom,x,y,fx,fy,tmp,dateTime,depth,isDouble) VALUES("$noM","$x","$y","$fx","$fy","$tmp","$datetime","$depth","$isDouble")');
    //上面这条语句等价于下面这条语句
    //int id=await database.insert("user_info", {'name': '徐晖'});
    if (kDebugMode) {
      print('新插入的数据的ID是：$id');
    }
  }

  ///删除表中所有记录
  Future<void> deleteAllRow() async {
    Database database = await _getDatabase();
    int count = await database.rawDelete('DELETE FROM measure_info');
    //上面这条语句等价于下面这条语句
    //int count=await database.delete("user_info");

    if (kDebugMode) {
      print('删除表中所有记录，共删除$count条记录');
    }
  }

  ///删除表中所有name字段为徐晖的记录
  Future<void> deleteRow() async {
    Database database = await _getDatabase();
    int count =
        await database.rawDelete('DELETE FROM measure_info WHERE id = ?', [1]);
    //上面这条语句等价于下面这条语句
    //int count=await database.delete("user_info",where: 'name = ?', whereArgs: ['徐晖']);

    if (kDebugMode) {
      print('删除表中所有name字段为徐晖的记录，共删除$count条记录');
    }
  }

  ///将表中所有name字段为徐晖的记录的name字段值改成王克鸿
  Future<void> updateRow() async {
    Database database = await _getDatabase();
    int count = await database.rawUpdate(
        "UPDATE measure_info SET name = ? WHERE name = ?", ['王克鸿', '徐晖']);
    //上面这条语句等价于下面这条语句
    //int count=await database.update("user_info", {'name': '王克鸿'}, where: 'name = ?', whereArgs: ['徐晖']);

    if (kDebugMode) {
      print('将表中所有name字段为徐晖的记录的name字段值改成王克鸿，共修改$count条记录');
    }
  }

  Future<List<MeasureModel>> querymeasures() async {
    Database database = await _getDatabase();
    List<Map<String, dynamic>> maps = await database.query('measure_info');
    return List.generate(maps.length, (i) {
      return MeasureModel(
        x: maps[i]['x'],
        y: maps[i]['y'],
        tmp: maps[i]['tmp'],
        noM: maps[i]['noM'],
        dateTime: maps[i]['dateTime'],
        fx: maps[i]['fx'],
        fy: maps[i]['fy'],
        depth: maps[i]['depth'],
        isDouble: maps[i]['isDouble'],
      );
    }).reversed.toList();
  }

  ///查询表中所有noM字段的值为目标组的数据
  Future<List<MeasureModel>> selectRow(int group) async {
    Database database = await _getDatabase();
    List<Map> list = await database
        .rawQuery('SELECT * FROM measure_info WHERE nom = ?', [group]);
    //上面这条语句等价于下面这条语句
    // List<Map> list =await database.query("user_info", where: 'name = ?', whereArgs: ['徐晖']);
    if (kDebugMode) {
      print('查询表中所有noM字段的值为$group的数据');
      print(list);
    }
    return List.generate(list.length, (i) {
      return MeasureModel(
        x: list[i]['x'],
        y: list[i]['y'],
        fx: list[i]['fx'],
        fy: list[i]['fy'],
        depth: list[i]['depth'],
        tmp: list[i]['tmp'],
        noM: list[i]['noM'],
        dateTime: list[i]['dateTime'],
        isDouble: list[i]['isDouble'],
      );
    }).reversed.toList();
  }

  ///查询表中所有noM字段的值为目标组的数据
  Future<List<MeasureModel>> selectDate(String datetime) async {
    Database database = await _getDatabase();
    List<Map> list = await database
        .rawQuery('SELECT * FROM measure_info WHERE dateTime = ?', [datetime]);
    //上面这条语句等价于下面这条语句
    // List<Map> list =await database.query("user_info", where: 'name = ?', whereArgs: ['徐晖']);
    if (kDebugMode) {
      print('查询表中所有noM字段的值为$datetime的数据');
      print(list);
    }
    return List.generate(list.length, (i) {
      return MeasureModel(
        x: list[i]['x'],
        y: list[i]['y'],
        fx: list[i]['fx'],
        fy: list[i]['fy'],
        depth: list[i]['depth'],
        tmp: list[i]['tmp'],
        noM: list[i]['noM'],
        dateTime: list[i]['dateTime'],
        isDouble: list[i]['isDouble'],
      );
    }).reversed.toList();
  }
}
