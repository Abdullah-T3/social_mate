import 'package:flutter/material.dart';

import '../../../../../../core/Responsive/Models/device_info.dart';

class PostsButtonWidget extends StatelessWidget {
  const PostsButtonWidget({
    super.key,
    required this.buttonColor,
    required this.text,
    required this.deviceInfo,
    required this.onPressed,
  });
  final Color buttonColor;
  final String text;
  final DeviceInfo deviceInfo;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: buttonColor,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(deviceInfo.localWidth * 0.03),
      ),
      child: Text(text),
    );
  }
}
