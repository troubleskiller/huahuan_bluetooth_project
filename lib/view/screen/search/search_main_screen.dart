import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:oem_huahuan220824_flutter/controller/measure_database_service.dart';
import 'package:oem_huahuan220824_flutter/view/screen/search/measure_excel.dart';

import '../../../Model/measure_model.dart';
import '../../../controller/event_database_service.dart';
import '../../../controller/hole_database_service.dart';
import '../../widgets/chart_widget/chart_break.dart';

class SearchMainScreen extends StatefulWidget {
  const SearchMainScreen({Key? key}) : super(key: key);

  @override
  State<SearchMainScreen> createState() => _SearchMainScreenState();
}

class _SearchMainScreenState extends State<SearchMainScreen> {
  var selectEventItemValue = 0;
  var selectHoleItemValue = 0;

  var selectMeasureItemValue = '请选择测量时间';

  List<EventModel> events = [];
  List<HoleModel> holes = [];
  List<String> dateTimes = [];

  List<MeasureModel> measures = [];
  List<DropdownMenuItem<int>> eventItems = [
    const DropdownMenuItem<int>(
      child: Text('请选择项目'),
      value: 0,
    ),
  ];
  List<DropdownMenuItem<int>> holeItems = [
    const DropdownMenuItem<int>(
      child: Text('请选择孔'),
      value: 0,
    ),
  ];
  List<DropdownMenuItem<String>> measureItems = [
    const DropdownMenuItem<String>(
      child: Text('请选择测量时间'),
      value: '请选择测量时间',
    ),
  ];
  final EventDatabaseService _eventDatabaseService = EventDatabaseService();
  final HoleDatabaseService _holeDatabaseService = HoleDatabaseService();
  final MeasureDatabaseService _measureDatabaseService =
      MeasureDatabaseService();

  MeasureModel? measureModel;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _queryEvents();
  }

  _queryEvents() async {
    // await _eventDatabaseService.init();
    events = await _eventDatabaseService.queryEvents();

    generateEventItemList();
    setState(() {});
  }

  List<DropdownMenuItem<int>> generateEventItemList() {
    for (EventModel event in events) {
      eventItems.add(DropdownMenuItem<int>(
        child: Text(event.name),
        value: event.id,
      ));
    }
    return eventItems;
  }

  Future generateHoleItemList(selectEventItemValue) async {
    holes = await _holeDatabaseService.selectRow(selectEventItemValue);
    List<DropdownMenuItem<int>> curHoleItems = [
      const DropdownMenuItem<int>(
        child: Text('请选择孔'),
        value: 0,
      ),
    ];
    for (HoleModel hole in holes) {
      curHoleItems.add(DropdownMenuItem<int>(
        child: Text(hole.name),
        value: hole.id,
      ));
    }
    holeItems = curHoleItems;
  }

  Future generateMeasureItemList(selectMeasureItemValue) async {
    List<String> dateTime = [];

    ///todo check if wrong;
    measures = await _measureDatabaseService.selectRow(selectMeasureItemValue);
    if (measures == []) {
      print('123');
      List<DropdownMenuItem<String>> curMeasureItems = [
        const DropdownMenuItem<String>(
          child: Text('请选择测量时间'),
          value: '请选择测量时间',
        ),
      ];
      measureItems = curMeasureItems;
    }
    for (MeasureModel measureModel in measures) {
      if (!dateTime.contains(measureModel.dateTime)) {
        dateTime.add(measureModel.dateTime);
      }
    }
    List<DropdownMenuItem<String>> curMeasureItems = [
      const DropdownMenuItem<String>(
        child: Text('请选择测量时间'),
        value: '请选择测量时间',
      ),
    ];
    for (String a in dateTime) {
      curMeasureItems.add(DropdownMenuItem<String>(
        child: Text(a),
        value: a,
      ));
    }
    measureItems = curMeasureItems;
    dateTimes = dateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '查询',
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
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton(
            items: eventItems,
            onChanged: (value) {
              if (selectHoleItemValue != 0) {
                BrnDialogManager.showConfirmDialog(context,
                    title: '监测到目前正处于其他孔项目选择中',
                    cancel: '取消',
                    confirm: '初始化项目查询', onConfirm: () async {
                  selectMeasureItemValue = '请选择测量时间';
                  selectHoleItemValue = 0;
                  selectEventItemValue = 0;
                  Navigator.pop(context);
                  generateHoleItemList(selectEventItemValue);
                  generateMeasureItemList(selectHoleItemValue);
                  setState(() {});
                });
              } else {
                if (value is int) {
                  setState(() {
                    selectEventItemValue = value;
                    generateHoleItemList(selectEventItemValue);
                  });
                  // print(value);
                }
              }
            },
            value: selectEventItemValue,
            isExpanded: true,
          ),
          DropdownButton(
            items: holeItems,
            onChanged: (value) {
              if (selectHoleItemValue != 0) {
                BrnDialogManager.showConfirmDialog(context,
                    title: '监测到目前正处于其他时间选择中',
                    cancel: '取消',
                    confirm: '初始化洞口查询', onConfirm: () async {
                  selectMeasureItemValue = '请选择测量时间';
                  selectHoleItemValue = 0;
                  Navigator.pop(context);
                  generateMeasureItemList(selectHoleItemValue);
                  setState(() {});
                });
              } else {
                if (value is int) {
                  setState(() {
                    selectHoleItemValue = value;
                    generateMeasureItemList(selectHoleItemValue);
                  });
                  // print(value);
                }
              }
            },
            value: selectHoleItemValue,
            isExpanded: true,
          ),
          DropdownButton(
            items: measureItems,
            onChanged: (value) {
              if (value is String) {
                setState(() {
                  selectMeasureItemValue = value;
                  // generateHoleItemList(selectEventItemValue);
                });
                // print(value);
              }
            },
            value: selectMeasureItemValue,
            isExpanded: true,
          ),
          Container(
            height: 20,
          ),
          GestureDetector(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border.fromBorderSide(
                      BorderSide(color: Colors.black, width: 1)),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              height: 50,
              width: 350,
              child: const Center(
                child: Text(
                  '孔型变化查看',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            onTap: () {
              BrnDialogManager.showConfirmDialog(context,
                  title: "当前版本仅支持查看与第一次的孔型变化查看",
                  cancel: '取消',
                  confirm: '确定', onConfirm: () async {
                BrnToast.show("确定", context);
                Navigator.pop(context);
                List<MeasureModel> curList = await _measureDatabaseService
                    .selectDate(selectMeasureItemValue);
                List<MeasureModel> preList = [];
                if (dateTimes.indexWhere(
                            (element) => element == selectMeasureItemValue) +
                        1 <=
                    dateTimes.length - 1) {
                  preList =
                      await _measureDatabaseService.selectDate(dateTimes.last);
                } else {
                  for (int i = 0; i < curList.length; i++) {
                    preList.add(MeasureModel(
                        noM: 0,
                        x: 0,
                        y: 0,
                        fx: 0,
                        fy: 0,
                        tmp: 0,
                        dateTime: '0',
                        depth: curList[i].depth,
                        isDouble: 2));
                  }
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChartBreakLine(
                              curList: curList,
                              preList: preList,
                            )));
              }, onCancel: () {
                BrnToast.show("取消", context);
                Navigator.pop(context);
              });
            },
          ),
          //work as margin
          Container(
            height: 30,
          ),
          GestureDetector(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border.fromBorderSide(
                      BorderSide(color: Colors.black, width: 1)),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              height: 50,
              width: 350,
              child: const Center(
                child: Text(
                  '孔形查看',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            onTap: () async {
              List<MeasureModel> measureList = await _measureDatabaseService
                  .selectDate(selectMeasureItemValue);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MeasureExcel(measureList: measureList)));
            },
          ),
        ],
      ),
    );
  }
}
