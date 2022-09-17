import 'package:flutter/material.dart';
import 'package:oem_huahuan220824_flutter/Model/measure_model.dart';
import 'package:oem_huahuan220824_flutter/controller/event_database_service.dart';
import 'package:oem_huahuan220824_flutter/view/widgets/dialog/dialog_content.dart';
import 'package:oem_huahuan220824_flutter/view/widgets/dialog/dialog_with_textfield.dart';
import 'package:oem_huahuan220824_flutter/view/widgets/measure_event.dart';

class MeasureMainScreen extends StatefulWidget {
  const MeasureMainScreen({Key? key}) : super(key: key);

  @override
  State<MeasureMainScreen> createState() => _MeasureMainScreenState();
}

final TextEditingController _nameController = TextEditingController();

final TextEditingController _describeController = TextEditingController();

class _MeasureMainScreenState extends State<MeasureMainScreen> {
  List<EventModel> _events = <EventModel>[];
  final EventDatabaseService _eventDatabaseService = EventDatabaseService();
  ScrollController scrollController = ScrollController();
  PageController pageController = PageController();
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _queryEvents();
  }

  _queryEvents() async {
    await _eventDatabaseService.init();
    _events = await _eventDatabaseService.queryEvents();
    // _events = await _database.queryEvents();
    // print(_events[0].describe);
    setState(() {});
  }

  List<Widget> _getEventsList(List<EventModel> events) {
    List<Widget> eventWidgets = <Widget>[];
    eventWidgets.add(const SizedBox(height: 6));
    for (EventModel event in events) {
      eventWidgets.add(
        MeasureEventList(
          eventModel: event,
        ),
      );
    }
    return eventWidgets;
  }

  void _newEvent() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return RenameDialog(
            contentWidget: RenameDialogContent(
              title: "新建一个项目",
              okBtnTap: () async {
                DateTime date = DateTime.now();
                String timestamp =
                    "${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

                await _eventDatabaseService.addRow(
                    _nameController.text, _describeController.text, timestamp);
                _events = await _eventDatabaseService.queryEvents();
                Navigator.of(context).pop();
                setState(() {});
              },
              nameController: _nameController,
              describeController: _describeController,
              cancelBtnTap: () {},
            ),
          );
        });
    // final result = await Navigator.push(context, _createRoute(_eventData));
    // if (result != null) {
    //   await _database.insertEvent(result);
    _events = await _eventDatabaseService.queryEvents();
    setState(() {});
  }

  @override
  void dispose() {
    // _nameController.dispose();
    // _describeController.dispose();
    super.dispose();
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
            children: _getEventsList(_events),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: _newEvent,
        tooltip: '新增条条',
        child: const Icon(Icons.add),
      ),
    );
  }
}
