import 'package:flutter/material.dart';
import 'package:oem_huahuan220824_flutter/Model/measure_model.dart';
import 'package:oem_huahuan220824_flutter/view/screen/measure/measure_datail_screen.dart';

class MeasureEventList extends StatelessWidget {
  const MeasureEventList({Key? key, required this.eventModel})
      : super(key: key);
  final EventModel eventModel;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ///todo: function to see the full information of the event.
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MeasureDetailScreen(group: eventModel.id)));
      },
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(width: 1), color: Colors.white),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            CommonLineForEvent(
                lineName: '序号:', lineEvent: eventModel.id.toString()),
            CommonLineForEvent(lineName: '项目名:', lineEvent: eventModel.name),
            CommonLineForEvent(lineName: '简介:', lineEvent: eventModel.describe),
            CommonLineForEvent(
                lineName: '创建时间:', lineEvent: eventModel.dateTime.toString()),
          ],
        ),
      ),
    );
  }
}

class CommonLineForEvent extends StatelessWidget {
  const CommonLineForEvent(
      {Key? key, required this.lineName, required this.lineEvent})
      : super(key: key);
  final String? lineName;
  final String? lineEvent;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(lineName ?? ''),
        Text(lineEvent ?? ''),
      ],
    );
  }
}
