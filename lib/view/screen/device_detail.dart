import 'dart:math';

import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oem_huahuan220824_flutter/Model/measure_model.dart';
import 'package:oem_huahuan220824_flutter/view/screen/main_screen.dart';

import '../../controller/measure_database_service.dart';
import '../../helper/common_helper.dart';

class DeviceDetail extends StatefulWidget {
  const DeviceDetail({
    Key? key,
    required this.device,
    required this.holeModel,
    this.isDouble = true,
  }) : super(key: key);

  final BluetoothDevice device;
  final HoleModel holeModel;
  final bool isDouble;

  @override
  State<DeviceDetail> createState() => _DeviceDetailState();
}

class _DeviceDetailState extends State<DeviceDetail> {
  late DateTime dateTime;
  int isDouble = 0;
  int holeCount = 0;
  int testCount = 0;

  int antiCount = 0;
  int preCount = 0;

  ///sin 后乘的
  double mult = 0;
  List<BluetoothService> services = [];
  BluetoothCharacteristic? readCharacteristic;
  BluetoothCharacteristic? characteristic;
  BluetoothCharacteristic? writeCharacteristic;
  List<BluetoothCharacteristic>? writeCharacteristics;
  List<double> _list = [0, 0, 0, 0];
  final MeasureDatabaseService _measureDatabaseService =
      MeasureDatabaseService();

  //正测
  List<double> measureList = [];
  List<List<double>> measureMainList = [];
  List<MeasureModel> trueList = [];

  bool isTest = true;

  bool doTest = true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    ///should do
    widget.device.disconnect();
    Fluttertoast.showToast(msg: '设备断开连接');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findServices();
    dateTime = DateTime.now();
    isDouble = widget.isDouble ? 2 : 1;
    mult = widget.holeModel.sideBet;
    setState(() {
      holeCount = CommonHelper.getHoleCount(widget.holeModel.holeWidth,
          widget.holeModel.restForTop, widget.holeModel.sideBet);
      preCount = holeCount;
    });

    ///should do
    widget.device.state.listen((state) {
      if (state == BluetoothDeviceState.disconnected) {
        print('设备断开了连接了');
        Navigator.pop(context);
      }
    });
  }

  saveMeasureData(List<MeasureModel> list) async {
    DateTime date = DateTime.now();
    String timestamp =
        "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

    for (MeasureModel measureModel in list) {
      _measureDatabaseService.addRow(
          measureModel.noM,
          measureModel.x,
          measureModel.y,
          measureModel.fx,
          measureModel.fy,
          measureModel.tmp,
          measureModel.depth,
          timestamp,
          isDouble);
    }
  }

  // _updateMeasureDetail(List<double> list) async {}

  List<Widget> _getMeasureList(List<double> list) {
    return <Widget>[
      Container(
        height: 50,
      ),
      SizedBox(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('当前测值X'),
            Text(list[0].toString()),
          ],
        ),
      ),
      SizedBox(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('当前测值Y'),
            Text(list[1].toString()),
          ],
        ),
      ),
      SizedBox(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('温度'),
            Text(list[2].toString()),
          ],
        ),
      ),
      SizedBox(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('电量'),
            Text(
              list[3].toString(),
              style: TextStyle(color: list[3] > 20 ? Colors.black : Colors.red),
            ),
          ],
        ),
      ),
    ];
  }

  void selectedButtonOnTap(BrnMultipleButtonArrowState state) {
    String info = "";
    switch (state) {
      case BrnMultipleButtonArrowState.unfold:
        info = '展开状态';
        break;
      case BrnMultipleButtonArrowState.cantUnfold:
        info = '无法展开状态';
        break;
      case BrnMultipleButtonArrowState.fold:
        info = '收起状态';
        break;
      case BrnMultipleButtonArrowState.defaultStatus:
        break;
    }
    BrnToast.show('已选择状态为 : $info', context);
  }

  @override
  Widget build(BuildContext context) {
    print(isDouble);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '测量',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MainScreen()));
          },
        ),
        centerTitle: true,
      ),
      body: ListView(
        key: UniqueKey(),
        children: [
          Column(
            children: _getMeasureList(_list),
          ),
          Offstage(
            offstage: !isTest,
            child: BrnEnhanceNumberCard(
              itemChildren: [
                BrnNumberInfoItemModel(
                  title: '待测量的孔的数量',
                  number: holeCount.toString(),
                )
              ],
            ),
          ),
          Offstage(
            offstage: !isTest,
            child: BrnMultipleBottomButton(
              bottomController: BrnMultipleBottomController(
                initMultiSelectState:
                    MultiSelectState(selectedCount: holeCount),
              ),
              onSelectedButtonTap: selectedButtonOnTap,
              hasArrow: false,
              mainButton: '保存本次测量',
              onMainButtonTap: () {
                if (holeCount >= 1) {
                  double x = _list[0];
                  double y = _list[1];
                  double tmp = _list[2];
                  double depth = widget.holeModel.sideBet * testCount;
                  List<double> value = [x, y, 0, 0, tmp, depth];
                  measureMainList.add(value);
                  print(value);
                  if (holeCount - 1 == 0) {
                    doTest = false;
                  }
                  setState(() {
                    holeCount--;
                    testCount++;
                  });
                } else {
                  BrnDialogManager.showSingleButtonDialog(context,
                      label: "确定", title: '提示', warning: '已经测完了', onTap: () {
                    BrnToast.show('知道了', context);
                    Navigator.pop(context);
                  });
                }
              },
              subButton: '删除上次测量记录',
              onSubButtonTap: () {
                if (holeCount <= preCount - 1) {
                  measureMainList.removeLast();
                  setState(() {
                    holeCount++;
                    testCount--;
                  });
                } else {
                  BrnDialogManager.showSingleButtonDialog(context,
                      label: "确定",
                      title: '提示',
                      warning: '没有可删的测量数据啦！', onTap: () {
                    BrnToast.show('知道了', context);
                    Navigator.pop(context);
                  });
                }
              },
            ),
          ),
          Offstage(
            offstage: !widget.isDouble || doTest,
            child: BrnBottomButtonPanel(
              mainButtonName: '进行反测',
              mainButtonOnTap: () {
                isTest = false;
                antiCount = preCount;
                setState(() {});
              },
            ),
          ),
          Offstage(
            offstage: isTest,
            child: BrnEnhanceNumberCard(
              itemChildren: [
                BrnNumberInfoItemModel(
                  title: '待测量的孔的数量',
                  number: antiCount.toString(),
                )
              ],
            ),
          ),
          Offstage(
            offstage: isTest,
            child: BrnMultipleBottomButton(
              bottomController: BrnMultipleBottomController(
                initMultiSelectState:
                    MultiSelectState(selectedCount: antiCount),
              ),
              onSelectedButtonTap: selectedButtonOnTap,
              hasArrow: false,
              mainButton: '保存本次测量',
              onMainButtonTap: () {
                if (antiCount >= 1) {
                  double x = _list[0];
                  double y = _list[1];
                  measureMainList[antiCount - 1][2] = x;
                  measureMainList[antiCount - 1][3] = y;
                  setState(() {
                    antiCount--;
                  });
                } else {
                  BrnDialogManager.showSingleButtonDialog(context,
                      label: "确定", title: '提示', warning: '已经测完了', onTap: () {
                    BrnToast.show('知道了', context);
                    Navigator.pop(context);
                  });
                }
              },
              subButton: '删除上次测量记录',
              onSubButtonTap: () {
                if (antiCount <= preCount - 1) {
                  measureMainList[antiCount][2] = 0;
                  measureMainList[antiCount][3] = 0;
                  setState(() {
                    antiCount++;
                  });
                } else {
                  BrnDialogManager.showSingleButtonDialog(context,
                      label: "确定",
                      title: '提示',
                      warning: '没有可删的测量数据啦！', onTap: () {
                    BrnToast.show('知道了', context);
                    Navigator.pop(context);
                  });
                }
              },
            ),
          ),
          BrnBottomButtonPanel(
            mainButtonName: '保存测量结果',
            mainButtonOnTap: () {
              for (List<double> a in measureMainList) {
                MeasureModel measureModel = MeasureModel(
                    noM: widget.holeModel.id,
                    x: a[0],
                    y: a[1],
                    fx: a[2],
                    fy: a[3],
                    tmp: a[4],
                    dateTime: dateTime.toIso8601String(),
                    depth: a[5],
                    isDouble: isDouble);
                trueList.add(measureModel);
              }
              saveMeasureData(trueList);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainScreen()));
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        ///should do
        await writeDataToDevice();
        // -----

        ///test - data
        // List value = [
        //   0x5A,
        //   0x46,
        //   0x2B,
        //   0x56,
        //   0x41,
        //   0x4C,
        //   0x55,
        //   0x45,
        //   0x53,
        //   0x3D,
        //   0x2D,
        //   0x31,
        //   0x30,
        //   0x2C,
        //   0x31,
        //   0x32,
        //   0x2C,
        //   0x32,
        //   0x37,
        //   0x2E,
        //   0x39,
        //   0x2C,
        //   0x37,
        //   0x2E,
        //   0x34,
        // ];
        // String res = "";
        // for (var i = 0; i < value.length; i++) {
        //   res += String.fromCharCode(int.parse(value[i].toRadixString(10)));
        // }
        // if (res != '') {
        //   List<String> differString = res.split(',');
        //
        //   ///包含ZF+VALUES=，以及x轴
        //
        //   String a = differString[0];
        //   List<String> b = a.split('=');
        //
        //   List<double> sol = [];
        //   double x =
        //       double.parse((sin(double.parse(b[1])) * mult).toStringAsFixed(3));
        //   double y = double.parse(
        //       (sin(double.parse(differString[1])) * mult).toStringAsFixed(3));
        //   double tmp = double.parse(differString[2]);
        //   double bat = CommonHelper.toInt(double.parse(differString[3]));
        //   sol.addAll([x, y, tmp, bat]);
        //   _list = sol;
        //   setState(() {});
        // }
      }),
    );
  }

  ///should do
  void findServices() async {
    services = await widget.device.discoverServices();
    for (var service in services) {
      // do something with service
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        if (c.properties.notify) {
          setCharacteristicNotify(c, true);
          print(c.uuid);
        }
        if (c.properties.write) {
          writeCharacteristics?.add(c);
        }
        if (c.uuid == Guid('0000fff2-0000-1000-8000-00805f9b34fb')) {
          print(c.uuid);
          writeCharacteristic = c;
        }
      }
    }
  }

  ///should do
  void setCharacteristicNotify(BluetoothCharacteristic c, bool notify) async {
    bool result = await c.setNotifyValue(notify);
    if (result) {
      print('set BluetoothCharacteristic Notify success');
      c.value.listen(
        (value) {
          String res = "";

          for (var i = 0; i < value.length; i++) {
            res += String.fromCharCode(int.parse(value[i].toRadixString(10)));
          }
          if (res != "") {
            List<String> differString = res.split(',');

            ///包含ZF+VALUES=，以及x轴

            String a = differString[0];
            List<String> b = a.split('=');

            List<double> sol = [];
            double x = double.parse(
                (sin(double.parse(b[1])) * mult).toStringAsFixed(6));
            double y = double.parse(
                (sin(double.parse(differString[1])) * mult).toStringAsFixed(6));
            double tmp = double.parse(differString[2]);
            double bat = CommonHelper.toInt(double.parse(differString[3]));
            sol.addAll([x, y, tmp, bat]);
            _list = sol;
            setState(() {});
          }
        },
      );
    } else {
      print('set BluetoothCharacteristic Notify fail');
    }
  }

  Future writeDataToDevice() async {
    writeCharacteristics?.forEach((element) {
      element.write(
          [0x5A, 0x46, 0x2B, 0x41, 0x55, 0x54, 0x4F, 0x3D, 0x31, 0x0D, 0x0A]);
    });
    writeCharacteristic?.write(
        [0x5A, 0x46, 0x2B, 0x41, 0x55, 0x54, 0x4F, 0x3D, 0x31, 0x0D, 0x0A]);
  }
}
