import 'package:flutter/material.dart';
import '../../Responsive/Models/device_info.dart';
import '../../theming/colors.dart';

class CustomDialogWidget extends StatelessWidget {
  const CustomDialogWidget({
    super.key,
    required this.deviceInfo,
    required this.title,
    required this.fields,
    required this.actions,
  });
  final DeviceInfo deviceInfo;
  final String title;
  final List<Widget> fields;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(deviceInfo.localWidth * 0.03),
      ),
      elevation: 8.0,
      child: SingleChildScrollView(
        child: Container(
          width: deviceInfo.localWidth * 0.8,
          padding: EdgeInsets.all(deviceInfo.localWidth * 0.05),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: deviceInfo.screenWidth * 0.05,
                  color: ColorsManager.blackColor,
                ),
              ),
              SizedBox(height: deviceInfo.localHeight * 0.02),

              // Input Fields
              ...fields,

              SizedBox(height: deviceInfo.localHeight * 0.03),

              // Action Buttons
              Row(mainAxisAlignment: MainAxisAlignment.end, children: actions),
            ],
          ),
        ),
      ),
    );
  }
}
