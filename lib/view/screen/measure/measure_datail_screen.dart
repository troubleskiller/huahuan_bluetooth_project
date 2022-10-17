import 'package:flutter/material.dart';
import 'package:oem_huahuan220824_flutter/Model/measure_model.dart';

import '../../../controller/hole_database_service.dart';
import '../../widgets/MeasureHoleList.dart';
import '../../widgets/dialog/dialog_full_content.dart';
import '../../widgets/dialog/dialog_with_textfield.dart';

class MeasureDetailScreen extends StatefulWidget {
  const MeasureDetailScreen({Key? key, required this.group}) : super(key: key);
  final int group;

  @override
  State<MeasureDetailScreen> createState() => _MeasureDetailScreenState();
}

final TextEditingController _nameController = TextEditingController();

final TextEditingController _sideController = TextEditingController();

final TextEditingController _topController = TextEditingController();

final TextEditingController _describeController = TextEditingController();

final TextEditingController _depthController = TextEditingController();

class _MeasureDetailScreenState extends State<MeasureDetailScreen> {
  List<HoleModel> _holes = <HoleModel>[];
  final HoleDatabaseService _holeDatabaseService = HoleDatabaseService();
  ScrollController scrollController = ScrollController();
  PageController pageController = PageController();

  @override
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    _queryHoles();
  }

  _queryHoles() async {
    // await _holeDatabaseService.init();
    _holes = await _holeDatabaseService.selectRow(widget.group);
    print(_holes.length);
    // _events = await _database.queryEvents();
    // print(_events[0].describe);
    setState(() {});
  }

  List<Widget> _getHolesList(List<HoleModel> holes) {
    List<Widget> holeWidgets = <Widget>[];
    holeWidgets.add(const SizedBox(height: 6));
    for (HoleModel hole in _holes) {
      holeWidgets.add(
        MeasureHoleList(
          holeModel: hole,
        ),
      );
    }
    return holeWidgets;
  }

  void _newEvent() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return RenameDialog(
            contentWidget: DialogFullContent(
              title: '新建测量孔',
              sideController: _sideController,
              describeController: _describeController,
              depthController: _depthController,
              nameController: _nameController,
              topController: _topController,
              okBtnTap: () async {
                DateTime date = DateTime.now();
                String timestamp =
                    "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

                await _holeDatabaseService.addRow(
                    widget.group,
                    _nameController.text,
                    double.parse(_depthController.text),
                    double.parse(_topController.text),
                    double.parse(_sideController.text),
                    timestamp);
                _holes = await _holeDatabaseService.selectRow(widget.group);
                Navigator.of(context).pop();

                setState(() {});
              },
              cancelBtnTap: () {
                Navigator.of(context).pop();
              },
            ),
          );
        });
    // final result = await Navigator.push(context, _createRoute(_eventData));
    // if (result != null) {
    //   await _database.insertEvent(result);
    _holes = await _holeDatabaseService.selectRow(widget.group);
    setState(() {});
  }

  @override
  void dispose() {
    // _nameController.dispose();
    // _describeController.dispose();
    // _sideController.dispose();
    // _topController.dispose();
    // _depthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false,
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
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: Container(
          color: Colors.black12,
          alignment: Alignment.center,
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: ListView(
            key: UniqueKey(),
            children: _getHolesList(_holes),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: _newEvent,
        tooltip: '新增条条',
        child: const Icon(Icons.add),
      ),
    );
  }
}
