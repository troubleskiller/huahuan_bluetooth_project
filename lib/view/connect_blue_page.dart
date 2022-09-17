import 'dart:async';

import 'package:bruno/bruno.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:oem_huahuan220824_flutter/Model/measure_model.dart';
import 'package:oem_huahuan220824_flutter/view/screen/device_detail.dart';

class ConnectBluePage extends StatefulWidget {
  const ConnectBluePage(
      {Key? key, required this.holeModel, this.isDouble = true})
      : super(key: key);
  final HoleModel holeModel;
  final bool isDouble;
  @override
  State<ConnectBluePage> createState() => _ConnectBluePageState();
}

class _ConnectBluePageState extends State<ConnectBluePage> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

  late StreamSubscription streamSubscription;
  List<ScanResult> scanResults = [];
  bool isDiscovering = false;

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  void dispose() {
    streamSubscription.cancel();
    super.dispose();
  }

  ///before
  Future<void> _onRefresh() async {
    flutterBlue.stopScan();
    if (kDebugMode) {
      print('开始扫描外设');
    }
    flutterBlue.startScan(timeout: const Duration(seconds: 4));
    flutterBlue.scanResults.listen((scanResult) {
      setState(() {
        scanResult.sort((left, right) => right.rssi.compareTo(left.rssi));
        scanResults.clear();
        for (ScanResult result in scanResult) {
          if (result.rssi > 0) continue;
          scanResults.add(result);
        }
      });
    });
  }

  void _connect(int index) async {
    BluetoothDevice device = scanResults[index].device;
    // await BluetoothConnection.toAddress(device.address);
    BrnLoadingDialog.show(context, content: '蓝牙连接中');

    ///should do
    await device.connect(
        // timeout: const Duration(seconds: 20), autoConnect: true
        );
    BrnLoadingDialog.dismiss(context);
    //   //跳转
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DeviceDetail(
                  device: device,
                  holeModel: widget.holeModel,
                  isDouble: widget.isDouble,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: const Text(
          '请选择你要连接的测量设备',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.replay,
              color: Colors.black,
            ),
            onPressed: _onRefresh,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: scanResults.length,
        itemBuilder: (BuildContext context, index) {
          ScanResult result = scanResults[index];
          return BluetoothDeviceListEntry(
            device: result.device,
            rssi: result.rssi,
            onTap: () async {
              _connect(index);
            },
          );
        },
      ),
    );
  }

  ///before
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(),
  //     body: Column(
  //       children: [
  //         MaterialButton(
  //           onPressed: () async {
  //             Map<Permission, PermissionStatus> statuses = await [
  //               Permission.bluetooth,
  //               Permission.bluetoothAdvertise,
  //               Permission.bluetoothConnect,
  //               Permission.bluetoothScan,
  //             ].request();
  //             print(statuses);
  //           },
  //           child: const Text("请求权限"),
  //         ),
  //         MaterialButton(
  //           onPressed: () async {
  //             flutterBlue.startScan(timeout: Duration(seconds: 4));
  //             flutterBlue.scanResults.listen((scanResult) {
  //               // do something with scan result
  //               setState(() {
  //                 scanResult
  //                     .sort((left, right) => right.rssi.compareTo(left.rssi));
  //                 scanResults.clear();
  //                 for (ScanResult result in scanResult) {
  //                   if (result.rssi > 0) continue;
  //                   scanResults.add(result);
  //                 }
  //               });
  //             });
  //           },
  //           child: const Text("开始扫描"),
  //         ),
  //         MaterialButton(
  //           onPressed: () {
  //             flutterBlue.stopScan();
  //           },
  //           child: const Text("停止扫描"),
  //         ),
  //         Expanded(
  //             child: RefreshIndicator(
  //           color: Colors.deepOrangeAccent,
  //           backgroundColor: Colors.white,
  //           child: ListView.separated(
  //             itemBuilder: (BuildContext context, int index) {
  //               String title = scanResults[index].device.name;
  //               String uuid = scanResults[index].device.id.id;
  //               int rssi = scanResults[index].rssi;
  //               return
  //                   // title.contains('Huahuan')
  //                   true
  //                       ? GestureDetector(
  //                           child: ListTile(
  //                             leading: Text("$rssi"),
  //                             title: Text(title),
  //                             subtitle: Text(uuid),
  //                             trailing: const Icon(Icons.arrow_forward_ios),
  //                           ),
  //                           onTap: () {
  //                             _connect(index);
  //                           },
  //                         )
  //                       : Container();
  //             },
  //             itemCount: scanResults.length,
  //             separatorBuilder: (BuildContext context, int index) {
  //               return true
  //                   ? const Divider(color: Colors.black38)
  //                   : Container();
  //             },
  //           ),
  //           onRefresh: _onRefresh,
  //         ))
  //       ],
  //     ),
  //   );
  // }
}

class BluetoothDeviceListEntry extends ListTile {
  BluetoothDeviceListEntry({
    Key? key,
    required BluetoothDevice device,
    int? rssi,
    GestureTapCallback? onTap,
    GestureLongPressCallback? onLongPress,
    bool enabled = true,
  }) : super(
          key: key,
          onTap: onTap,
          onLongPress: onLongPress,
          enabled: enabled,
          leading: const Icon(
              Icons.devices), // @TODO . !BluetoothClass! class aware icon
          title: Text(device.name),
          subtitle: Text(device.id.id),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              rssi != null
                  ? Container(
                      margin: const EdgeInsets.all(8.0),
                      child: DefaultTextStyle(
                        style: _computeTextStyle(rssi),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(rssi.toString()),
                            const Text('dBm'),
                          ],
                        ),
                      ),
                    )
                  : Container(width: 0, height: 0),
              // device.isConnected
              //     ? Icon(Icons.import_export)
              //     : Container(width: 0, height: 0),
            ],
          ),
        );

  static TextStyle _computeTextStyle(int rssi) {
    /**/ if (rssi >= -35) {
      return TextStyle(color: Colors.greenAccent[700]);
    } else if (rssi >= -45) {
      return TextStyle(
          color: Color.lerp(
              Colors.greenAccent[700], Colors.lightGreen, -(rssi + 35) / 10));
    } else if (rssi >= -55) {
      return TextStyle(
          color: Color.lerp(
              Colors.lightGreen, Colors.lime[600], -(rssi + 45) / 10));
    } else if (rssi >= -65) {
      return TextStyle(
          color: Color.lerp(Colors.lime[600], Colors.amber, -(rssi + 55) / 10));
    } else if (rssi >= -75) {
      return TextStyle(
          color: Color.lerp(
              Colors.amber, Colors.deepOrangeAccent, -(rssi + 65) / 10));
    } else if (rssi >= -85) {
      return TextStyle(
          color: Color.lerp(
              Colors.deepOrangeAccent, Colors.redAccent, -(rssi + 75) / 10));
    } else {
      return const TextStyle(color: Colors.redAccent);
    }
  }
}
