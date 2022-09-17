import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oem_huahuan220824_flutter/Model/measure_model.dart';
import 'package:oem_huahuan220824_flutter/view/screen/main_screen.dart';

import '../../helper/common_helper.dart';

class Test extends StatefulWidget {
  const Test({
    Key? key,
    required this.device,
  }) : super(key: key);

  final BluetoothDevice device;

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  late DateTime dateTime;

  ///sin 后乘的
  double mult = 0;
  List<BluetoothService> services = [];
  BluetoothCharacteristic? readCharacteristic;
  BluetoothCharacteristic? characteristic;
  BluetoothCharacteristic? writeCharacteristic;
  List<double> _list = [0, 0, 0, 0];

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

    ///should do
    // widget.device.state.listen((state) {
    //   if (state == BluetoothDeviceState.disconnected) {
    //     print('设备断开了连接了');
    //     Navigator.pop(context);
    //   }
    // });
  }

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

  @override
  Widget build(BuildContext context) {
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
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        ///should do
        await writeDataToDevice();
        // -----

        // ///test - data
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
        //   double x = double.parse(b[1]);
        //   double y = double.parse(differString[1]);
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
          if (res != '') {
            List<String> differString = res.split(',');

            ///包含ZF+VALUES=，以及x轴

            String a = differString[0];
            List<String> b = a.split('=');

            List<double> sol = [];
            double x = double.parse(
                (sin(double.parse(b[1])) * mult).toStringAsFixed(3));
            double y = double.parse(
                (sin(double.parse(differString[1])) * mult).toStringAsFixed(3));
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
    writeCharacteristic?.write(
        [0x5A, 0x46, 0x2B, 0x41, 0x55, 0x54, 0x4F, 0x3D, 0x31, 0x0D, 0x0A]);
  }
}
