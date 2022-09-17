///测量的不同的项目的数据
class EventModel {
  EventModel({
    required this.dateTime,
    required this.name,
    required this.describe,
    required this.id,
  });

  //项目的序号
  int id;

  //项目的名字
  String name;

  //项目的描述
  String describe;

  //项目创建的时间
  String dateTime;

  factory EventModel.fromJson(Map<String, dynamic> parsedJson) {
    // List<HoleModel> _getHoles(List<dynamic> subNoteMaps) {
    //   List<HoleModel> subNotes = <HoleModel>[];
    //   for (dynamic subNote in subNoteMaps) {
    //     subNotes.add(subNote);
    //   }
    //   return subNotes;
    // }

    return EventModel(
      id: parsedJson['id'],
      name: parsedJson['name'],
      describe: parsedJson['describe'],
      dateTime: parsedJson['datetime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'describe': describe,
      'datetime': dateTime,
    };
  }
}

///项目内不同的孔的数据
class HoleModel {
  //孔的分组
  int noM;

  //孔的序号
  int id;

  //孔的名字
  String name;

  //孔的深度
  double holeWidth;

  ///todo int -double

  //顶部的预留高度
  double restForTop;

  //测量的间隔
  double sideBet;

  //创建的时间
  String dateTime;

  HoleModel({
    required this.dateTime,
    required this.name,
    required this.id,
    required this.noM,
    required this.holeWidth,
    required this.restForTop,
    required this.sideBet,
  });

  factory HoleModel.fromJson(Map<String, dynamic> parsedJson) {
    return HoleModel(
      id: parsedJson['id'],
      name: parsedJson['name'],
      holeWidth: parsedJson['holeWidth'],
      dateTime: parsedJson['datetime'],
      restForTop: parsedJson['restForTop'],
      sideBet: parsedJson['sideBet'],
      noM: parsedJson['noM'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'holeWidth': holeWidth,
      'datetime': dateTime,
      'restForTop': restForTop,
      'sideBet': sideBet,
      'noM': noM,
    };
  }
}

///孔内不同时间测量的数据
class MeasureModel {
  //different hole
  int noM;

  //x -偏移
  double x;

  //y -偏移
  double y;

  //fan x -偏移
  double fx;

  //fan y -偏移
  double fy;

  //y -偏移
  double tmp;

  String dateTime;

  double depth;

  int isDouble;

  MeasureModel({
    required this.noM,
    required this.x,
    required this.y,
    required this.fx,
    required this.fy,
    required this.tmp,
    required this.dateTime,
    required this.depth,
    required this.isDouble,
  });

  factory MeasureModel.fromJson(Map<String, dynamic> parsedJson) {
    return MeasureModel(
      noM: parsedJson['noM'],
      isDouble: parsedJson['isDouble'],
      x: parsedJson['x'],
      y: parsedJson['y'],
      tmp: parsedJson['tmp'],
      dateTime: parsedJson['dateTime'],
      fy: parsedJson['fy'],
      fx: parsedJson['fx'],
      depth: parsedJson['depth'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'fx': fx,
      'fy': fy,
      'datetime': dateTime,
      'tmp': tmp,
      'noM': noM,
      'depth': depth,
      'isDouble': isDouble,
    };
  }
}
