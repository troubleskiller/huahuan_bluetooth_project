import 'package:flutter/material.dart';

class RenameDialog extends AlertDialog {
  RenameDialog({Key? key, required Widget contentWidget})
      : super(
          key: key,
          content: contentWidget,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.black, width: 3)),
        );
}
