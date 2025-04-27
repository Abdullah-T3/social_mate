import 'package:flutter/material.dart';
import 'package:social_mate/core/Responsive/Models/device_info.dart';
import 'package:social_mate/core/theming/colors.dart';
import 'package:social_mate/core/theming/styles.dart';

class ShowDeleteDialogWidget extends StatelessWidget {
  const ShowDeleteDialogWidget({
    super.key,
    required this.deviceInfo,
    this.onPressed,
  });
  final DeviceInfo deviceInfo;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorsManager.whiteColor,
      title: Text(
        'Confirm Delete',
        style: TextStyles.inter18BoldBlack.copyWith(
          fontSize: deviceInfo.screenWidth * 0.05,
        ),
      ),
      content: Text(
        'Are you sure you want to delete this post?',
        style: TextStyles.inter18Regularblack.copyWith(
          fontSize: deviceInfo.screenWidth * 0.04,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Cancel action
          child: Text(
            'Cancel',
            style: TextStyles.inter18Regularblack.copyWith(
              color: ColorsManager.primaryColor,
            ),
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            'Delete',
            style: TextStyles.inter18Regularblack.copyWith(
              color: ColorsManager.redColor,
            ),
          ),
        ),
      ],
    );
  }
}
