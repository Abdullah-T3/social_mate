import 'package:flutter/material.dart';
import '../../../../../../core/Responsive/Models/device_info.dart';
import '../../../../../../core/shared/widgets/cherryToast/CherryToastMsgs.dart';

class BuildErrorWidget extends StatelessWidget {
  const BuildErrorWidget({
    super.key,
    required this.deviceInfo,
    required this.message,
  });

  final DeviceInfo deviceInfo;
  final String message;

  @override
  Widget build(BuildContext context) {
    // Show the toast after the build process completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CherryToastMsgs.CherryToastError(
        info: deviceInfo,
        context: context,
        title: 'Error',
        description: message,
      );
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: deviceInfo.localWidth * 0.04,
              color: Colors.red,
            ),
          ),
          SizedBox(height: deviceInfo.localHeight * 0.02),
        ],
      ),
    );
  }
}
