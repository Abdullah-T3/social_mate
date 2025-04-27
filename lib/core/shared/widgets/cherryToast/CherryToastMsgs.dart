import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';

import '../../../Responsive/Models/device_info.dart';

class CherryToastMsgs {
  // ignore: non_constant_identifier_names
  static CherryToastSuccess({
    required DeviceInfo info,
    required BuildContext context,
    required String title,
    required String description,
    AnimationType animationType = AnimationType.fromTop,
    Duration duration = const Duration(seconds: 3),
  }) {
    return CherryToast.success(
      title: Text(title, style: TextStyle(color: Colors.white)),
      toastDuration: duration,
      borderRadius: info.screenWidth * 0.04,
      backgroundColor: Colors.green,
      shadowColor: Colors.black45,
      animationDuration: Duration(milliseconds: 300),
      animationType: animationType,
      autoDismiss: true,
      description: Text(description, style: TextStyle(color: Colors.white70)),
    ).show(context);
  }

  // ignore: non_constant_identifier_names
  static CherryToastError({
    required DeviceInfo info,
    required BuildContext context,
    required String title,
    required String description,
    AnimationType animationType = AnimationType.fromTop,
    Duration duration = const Duration(seconds: 3),
  }) {
    return CherryToast.error(
      title: Text(title, style: TextStyle(color: Colors.white)),
      toastDuration: duration,
      borderRadius: info.screenWidth * 0.04,
      backgroundColor: Color(0xff9b0d0d),
      shadowColor: Colors.black45,
      animationDuration: Duration(milliseconds: 300),
      animationType: animationType,
      autoDismiss: true,
      description: Text(description, style: TextStyle(color: Colors.white70)),
    ).show(context);
  }
}
