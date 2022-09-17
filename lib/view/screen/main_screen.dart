import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:oem_huahuan220824_flutter/controller/measure_database_service.dart';
import 'package:oem_huahuan220824_flutter/view/screen/login/login_screen.dart';
import 'package:oem_huahuan220824_flutter/view/screen/search/search_main_screen.dart';
import 'package:oem_huahuan220824_flutter/view/test/test_screen.dart';

import '../../controller/event_database_service.dart';
import '../../controller/hole_database_service.dart';
import 'measure/measure_main_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            '滑动测斜',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 100,
            ),
            GestureDetector(
              child: Container(
                height: 75,
                width: 150,
                child: const Center(child: Text('测量')),
                color: Colors.blue,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MeasureMainScreen()));
              },
            ),
            GestureDetector(
              child: Container(
                height: 75,
                width: 150,
                child: const Center(child: Text('查询')),
                color: Colors.blueGrey,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchMainScreen()));
              },
            ),
            GestureDetector(
              child: Container(
                height: 75,
                width: 150,
                child: const Center(child: Text('测试')),
                color: Colors.grey,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TestScreen()));
              },
            ),
            Container(
              height: 100,
            ),
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  '上海华桓电子科技有限公司',
                  textStyle: const TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.bold,
                  ),
                  speed: const Duration(milliseconds: 200),
                ),
              ],
              totalRepeatCount: 4,
              pause: const Duration(milliseconds: 1000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            )
            // const Text('上海华桓电子科技有限公司'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: '初始化数据库',
          onPressed: () {
            BrnDialogManager.showConfirmDialog(context,
                title: "此按钮用于初始化数据库",
                cancel: '我已完成初始化',
                confirm: '我是第一次初始化', onConfirm: () async {
              BrnToast.show("确定", context);
              Navigator.pop(context);
              EventDatabaseService().createTable();
              HoleDatabaseService().init();
              MeasureDatabaseService().init();
            }, onCancel: () {
              BrnToast.show("取消", context);
              Navigator.pop(context);
            });
            // /初始化数据库

            ///删除数据库
            // EventDatabaseService().deleteTable();
            // HoleDatabaseService().deleteTable();
            // // MeasureDatabaseService().selectAllRow();
            // MeasureDatabaseService().deleteTable();
          },
        ));
  }
}
