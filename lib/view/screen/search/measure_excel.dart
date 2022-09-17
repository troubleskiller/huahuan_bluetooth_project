import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:oem_huahuan220824_flutter/Model/measure_model.dart';
import 'package:oem_huahuan220824_flutter/helper/common_helper.dart';

class MeasureExcel extends StatefulWidget {
  const MeasureExcel({Key? key, required this.measureList}) : super(key: key);

  final List<MeasureModel> measureList;
  @override
  State<MeasureExcel> createState() => _MeasureExcelState();
}

class _MeasureExcelState extends State<MeasureExcel> {
  double? xChange;
  double? yChange;
  @override
  Widget build(BuildContext context) {
    List<ExcelModel> xList = [];
    List<double> xAdd = [];
    List<double> yAdd = [];
    List<ExcelModel> yList = [];
    for (MeasureModel measureModel in widget.measureList) {
      xChange = CommonHelper.convertMeasure(
          measureModel.x, measureModel.fx, measureModel.isDouble);
      yChange = CommonHelper.convertMeasure(
          measureModel.y, measureModel.fy, measureModel.isDouble);
      xList.add(
          ExcelModel(depth: measureModel.depth.toString(), change: xChange!));
      yList.add(
          ExcelModel(depth: measureModel.depth.toString(), change: yChange!));
      xAdd.add(xChange!);
      yAdd.add(yChange!);
    }
    List<double> xRes = CommonHelper.toAdd(xAdd);
    List<double> yRes = CommonHelper.toAdd(yAdd);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            '孔型查看',
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: DataTable2(
              columnSpacing: 12,
              horizontalMargin: 12,
              minWidth: 100,
              columns: const [
                DataColumn2(label: Text('深度'), size: ColumnSize.S),
                DataColumn2(label: Text('偏移X'), size: ColumnSize.L),
                DataColumn2(label: Text('偏移Y'), size: ColumnSize.L),
                DataColumn2(label: Text('孔形X'), size: ColumnSize.L),
                DataColumn2(label: Text('孔形Y'), size: ColumnSize.L),
              ],
              rows: List<DataRow>.generate(
                  xList.length,
                  (index) => DataRow(cells: [
                        DataCell(Text(xList[index].depth)),
                        DataCell(Text(xList[index].change.toStringAsFixed(3))),
                        DataCell(Text(yList[index].change.toStringAsFixed(3))),
                        DataCell(Text(xRes[index].toStringAsFixed(3))),
                        DataCell(Text(yRes[index].toStringAsFixed(3))),
                      ]))),
        ));
  }
}

class ExcelModel {
  double change;
  String depth;

  ExcelModel({required this.depth, required this.change});
}
