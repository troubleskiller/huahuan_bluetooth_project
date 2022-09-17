import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oem_huahuan220824_flutter/Model/measure_model.dart';

TextStyle smallTextStyle = const TextStyle(
    color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal);

class AddEvent extends StatefulWidget {
  const AddEvent({Key? key, this.nextId}) : super(key: key);

  final int? nextId;
  @override
  _AddEventState createState() => _AddEventState();
}

final ScrollController scrollController = ScrollController();

TextEditingController _controller = TextEditingController();

TextEditingController _controllerName = TextEditingController();

//设置提示框，当输入完成后，输入信息
String _textShowStr = "等待输入";

EventModel? eventModel;

Timer? timer;

int? nextId;

class _AddEventState extends State<AddEvent> {
  @override
  void initState() {
    super.initState();

    if (widget.nextId == null) {
      // eventBloc.getNextId().then((value) {
      //   nextId = value;
      // });
    } else {
      nextId = widget.nextId!;
    }

    setState(() {});

    timer = Timer.periodic(Duration(seconds: 20), (timer) {
      // if (timer.isActive) saveContent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: Column(
        children: <Widget>[
          TextField(
            //文本输入框组件

            controller: _controller, //设置控制器，这个控制器能获取输入框内容

            decoration: const InputDecoration(
              //设置输入框装饰器
              icon: Icon(Icons.phone_iphone),
              contentPadding: EdgeInsets.all(10.0), //内容内边距
              labelText: "姓名",
              helperText: "请输入手机号",
            ),

            autofocus: false, //自动获取焦点，设置false
          ),
          TextField(
            controller: _controllerName,
            decoration: const InputDecoration(
              labelText: "描述",
            ),
            autofocus: false,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // eventBloc.addEvent(EventModel(
              //     dateTime: DateTime.now(),
              //     name: _controller.text,
              //     describe: _controllerName.text,
              //     id: eventBloc.nextId!,
              //     holeList: []));
            }, //执行提交方法,
          ),
          Container(
            //提示框

            child: Text(_textShowStr),
          )
        ],
      ),
    );
  }
}
