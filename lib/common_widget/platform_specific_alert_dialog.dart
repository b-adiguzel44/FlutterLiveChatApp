import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_munasaka/common_widget/platform_specific_widget.dart';

class PlatformSpecificAlertDialog extends PlatformSpecificWidget {

  final String label;
  final String description;
  final String mainButtonLabel;
  final String cancelButtonLabel;

  PlatformSpecificAlertDialog({required this.label, required this.description,
        required this.mainButtonLabel,
        this.cancelButtonLabel = ""});

  Future<bool?> show(BuildContext context) async {

    return Platform.isIOS
        ? await showCupertinoDialog(
            context: context, builder: (context) => this)
        :
        await showDialog<bool>(
            context: context,
            builder: (context) => this,
            barrierDismissible: false);
  }

  // concrete
  @override
  Widget buildAndroidWidget(BuildContext context) {

    return AlertDialog(
      title: Text(label),
      content: Text(description),
      actions: _DesignDialogButtons(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(label),
      content: Text(description),
      actions: _DesignDialogButtons(context),
    );
  }

  List<Widget> _DesignDialogButtons(BuildContext context) {

    final allButtons = <Widget>[];

    if(Platform.isIOS) {

      if(cancelButtonLabel != null && cancelButtonLabel.isNotEmpty) {
        allButtons.add(
          CupertinoDialogAction(
            child: Text(cancelButtonLabel),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }

      allButtons.add(
        CupertinoDialogAction(
          child: Text("Tamam"),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );


    } else {
      // ANDROID PLATFORM
      if(cancelButtonLabel != null && cancelButtonLabel.isNotEmpty) {
        allButtons.add(
          TextButton(
            child: Text(cancelButtonLabel),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }

      allButtons.add(
        TextButton(child: Text("Tamam"),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );

    }

    return allButtons;
  }
}