import 'package:flutter/material.dart';

import 'dialog/dialog_content.dart';
import 'dialog/dialog_with_textfield.dart';

class AddEventLine extends StatelessWidget {
  const AddEventLine(
      {Key? key,
      required this.title,
      required this.onSaveButton,
      required this.nameController,
      required this.describeController})
      : super(key: key);
  final String title;
  final TextEditingController nameController;
  final TextEditingController describeController;
  final Function onSaveButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(TextSpan(children: [
            const WidgetSpan(child: Icon(Icons.event_note_outlined)),
            TextSpan(text: title),
          ])),
          GestureDetector(
            child: const Icon(Icons.add_box_rounded),
            onTap: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return RenameDialog(
                      contentWidget: RenameDialogContent(
                        title: "新建一个项目",
                        okBtnTap: () {
                          print(
                            "输入框中的文字为:${nameController.text}",
                          );
                          onSaveButton();
                        },
                        nameController: nameController,
                        describeController: describeController,
                        cancelBtnTap: () {},
                      ),
                    );
                  });
            },
          )
        ],
      ),
    );
  }
}
