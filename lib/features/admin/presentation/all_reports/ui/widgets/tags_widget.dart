import 'package:flutter/material.dart';

import '../../../../../../core/Responsive/Models/device_info.dart'
    show DeviceInfo;
import '../../../../../../core/theming/colors.dart' show ColorsManager;
import '../../../../../../core/theming/styles.dart';

class TagsWidget extends StatelessWidget {
  final DeviceInfo deviceInfo;
  final String tagName;
  final Color tileColor;
  final Color textColor;

  const TagsWidget({
    super.key,
    required this.deviceInfo,
    required this.tagName,
    required this.tileColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: deviceInfo.screenHeight * 0.03),
      child: Container(
        alignment: Alignment.center,
        width: deviceInfo.screenWidth * 0.38,
        height: deviceInfo.screenHeight * 0.04,
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(deviceInfo.screenWidth * 0.015),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: ColorsManager.greyColor,
              spreadRadius: 0.5,
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: deviceInfo.screenWidth * 0.02,
          ),
          child: Text(
            tagName,
            style: TextStyles.inter16Bold.copyWith(
              color: textColor,
              fontSize: deviceInfo.screenWidth * 0.038,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
