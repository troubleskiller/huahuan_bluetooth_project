import 'dart:math';

import 'package:bruno/bruno.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:oem_huahuan220824_flutter/helper/common_helper.dart';

import '../../../Model/measure_model.dart';

class ChartBreakLine extends StatefulWidget {
  const ChartBreakLine({Key? key, required this.curList, required this.preList})
      : super(key: key);
  final List<MeasureModel> curList;
  final List<MeasureModel> preList;

  @override
  _ChartBreakLineState createState() => _ChartBreakLineState();
}

Widget _brokenLineDemo1(context, List<DBDataNodeModel>? brokenData,
    List<DBDataNodeModel>? brokenYData) {
  if (brokenData == null || brokenYData == null) return Container();
  return Column(
    children: <Widget>[
      const SizedBox(
        height: 20,
      ),
      BrnBrokenLine(
        showPointDashLine: true,
        yHintLineOffset: 30,
        isTipWindowAutoDismiss: false,
        lines: [
          BrnPointsLine(
            isShowPointText: false,
            isShowXDial: true,
            lineWidth: 3,
            pointRadius: 4,
            isShowPoint: true,
            isCurve: true,
            points: _linePointsForDemo1(brokenData),
            shaderColors: [
              Colors.green.withOpacity(0.3),
              Colors.green.withOpacity(0.01)
            ],
            lineColor: Colors.green,
          ),
          BrnPointsLine(
            isShowPointText: false,
            isShowXDial: true,
            lineWidth: 3,
            pointRadius: 4,
            isShowPoint: true,
            isCurve: true,
            points: _linePointsForDemo1(brokenYData),
            shaderColors: [
              Colors.blue.withOpacity(0.3),
              Colors.blue.withOpacity(0.01)
            ],
            lineColor: Colors.blue,
          ),
        ],
        size: Size(MediaQuery.of(context).size.width * 1 - 100 * 2,
            MediaQuery.of(context).size.height / 5 * 1.6 - 20 * 2),
        isShowXHintLine: true,
        xDialValues: _getXDialValuesForDemo1(brokenData, brokenYData),
        xDialMin: min(_getMinXValues(brokenData), _getMinXValues(brokenYData)),
        xDialMax: max(_getMaxXValues(brokenData), _getMaxXValues(brokenYData)),
        yDialValues: _getYDialValuesForDemo1(brokenData),
        yDialMin: _getMinValueForDemo1(brokenData),
        yDialMax: _getMaxValueForDemo1(brokenData),
        isHintLineSolid: false,
        isShowYDialText: true,
        isShowXDialText: true,
      ),
    ],
    crossAxisAlignment: CrossAxisAlignment.start,
  );
}

double _getMaxXValues(List<DBDataNodeModel> brokenData) {
  double maxValue = double.tryParse(brokenData[0].name) ?? 0;
  for (DBDataNodeModel point in brokenData) {
    maxValue = max(double.tryParse(point.name) ?? 0, maxValue);
  }
  return maxValue + 0.1;
}

double _getMinXValues(List<DBDataNodeModel> brokenData) {
  double minValue = double.tryParse(brokenData[0].name) ?? 0;
  for (DBDataNodeModel point in brokenData) {
    minValue = min(double.tryParse(point.name) ?? 0, minValue);
  }
  return minValue;
}

List<BrnPointData> _linePointsForDemo1(List<DBDataNodeModel> brokenData) {
  return brokenData
      .map((_) => BrnPointData(
          pointText: _.value,
          x: double.parse(_.name),
          y: double.parse(_.value),
          lineTouchData: BrnLineTouchData(
              tipWindowSize: Size(60, 40),
              onTouch: () {
                return _.value;
              })))
      .toList();
}

List<BrnDialItem> _getYDialValuesForDemo1(List<DBDataNodeModel> brokenData) {
  List<BrnDialItem> _xDialValue = [];
  for (int index = 0; index < brokenData.length; index++) {
    _xDialValue.add(BrnDialItem(
      dialText: brokenData[index].value.substring(0, 3),
      dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF999999)),
      value: double.parse(brokenData[index].value.substring(0, 3)),
    ));
  }
  return _xDialValue;
  // double min = _getMinValueForDemo1(brokenData);
  // double max = _getMaxValueForDemo1(brokenData);
  // double dValue = (max - min) / 10;
  // List<BrnDialItem> _yDialValue = [];
  // for (int index = 0; index <= 10; index++) {
  //   _yDialValue.add(BrnDialItem(
  //     dialText: '${(min + index * dValue).ceil()}',
  //     dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF999999)),
  //     value: (min + index * dValue).ceilToDouble(),
  //   ));
  // }
  //
  // return _yDialValue;
}

double _getMinValueForDemo1(List<DBDataNodeModel> brokenData) {
  double minValue = double.tryParse(brokenData[0].value) ?? 0;
  for (DBDataNodeModel point in brokenData) {
    minValue = min(double.tryParse(point.value) ?? 0, minValue);
  }
  return minValue;
}

double _getMaxValueForDemo1(List<DBDataNodeModel> brokenData) {
  double maxValue = double.tryParse(brokenData[0].value) ?? 0;
  for (DBDataNodeModel point in brokenData) {
    maxValue = max(double.tryParse(point.value) ?? 0, maxValue);
  }
  return maxValue;
}

List<BrnDialItem> _getXDialValuesForDemo1(
    List<DBDataNodeModel> brokenData, List<DBDataNodeModel> brokenYData) {
  // double min = _getMinValueForDemo1(brokenData);
  // double max = _getMaxValueForDemo1(brokenData);
  // double dValue = (max - min) / 10;
  // List<BrnDialItem> _xDialValue = [];
  // for (int index = 0; index <= 10; index++) {
  //   _xDialValue.add(BrnDialItem(
  //     dialText: '${(min + index * dValue).ceil()}',
  //     dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF999999)),
  //     value: (min + index * dValue).ceilToDouble(),
  //   ));
  // }
  //
  // return _xDialValue;
  List<BrnDialItem> _xDialValue = [];
  for (int index = 0; index < brokenData.length; index++) {
    _xDialValue.add(BrnDialItem(
        dialText: brokenData[index].name,
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF999999)),
        value: double.parse(brokenData[index].name)));
  }
  for (int index = 0; index < brokenYData.length; index++) {
    _xDialValue.add(BrnDialItem(
        dialText: brokenYData[index].name,
        dialTextStyle: TextStyle(fontSize: 12.0, color: Color(0xFF999999)),
        value: double.parse(brokenYData[index].name)));
  }

  return _xDialValue;
}

class _ChartBreakLineState extends State<ChartBreakLine> {
  double? xChange;
  double? yChange;

  @override
  Widget build(BuildContext context) {
    List<DBDataNodeModel> brokenData = [];
    List<DBDataNodeModel> brokenYData = [];

    for (MeasureModel curModel in widget.curList) {
      double depth = curModel.depth;
      for (MeasureModel preModel in widget.preList) {
        if (depth == preModel.depth) {
          xChange = CommonHelper.convertMeasure(
                  curModel.x, curModel.fx, curModel.isDouble) -
              CommonHelper.convertMeasure(
                  preModel.x, preModel.fx, preModel.isDouble);
          yChange = CommonHelper.convertMeasure(
                  curModel.y, curModel.fy, curModel.isDouble) -
              CommonHelper.convertMeasure(
                  preModel.y, preModel.fy, preModel.isDouble);
          brokenData.add(
            DBDataNodeModel(
                value: depth.toString(), name: xChange!.toStringAsFixed(3)),
          );
          brokenYData.add(
            DBDataNodeModel(
                value: depth.toString(), name: yChange!.toStringAsFixed(3)),
          );
        }
      }
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            '曲线展示',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Container(
              child: Center(
                child: _brokenLineDemo1(context, brokenData, brokenYData),
              ),
            ),
            Expanded(
              child: DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 100,
                  columns: const [
                    DataColumn2(
                      label: Text('深度'),
                    ),
                    DataColumn(
                      label: Text('偏移X'),
                    ),
                    DataColumn(
                      label: Text('偏移Y'),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                      brokenData.length,
                      (index) => DataRow(cells: [
                            DataCell(Text(brokenData[index].value)),
                            DataCell(Text(brokenData[index].name)),
                            DataCell(Text(brokenYData[index].name)),
                          ]))),
            )
          ],
        ));
  }
}

class DBDataNodeModel {
  String name;
  String value;

  DBDataNodeModel({required this.value, required this.name});
}
