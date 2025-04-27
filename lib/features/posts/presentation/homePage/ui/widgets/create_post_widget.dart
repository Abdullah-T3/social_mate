import 'package:flutter/material.dart';

import '../../../../../../core/Responsive/Models/device_info.dart';
import '../../../../../../core/shared/widgets/show_create_post_dialog_widget.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/styles.dart';

class CreatePostWidget extends StatelessWidget {
  const CreatePostWidget({super.key, required this.deviceInfo});

  final DeviceInfo deviceInfo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return ShowCreatePostDialogWidget(deviceInfo: deviceInfo);
          },
        );
      },
      child: Container(
        width: deviceInfo.localWidth * 0.9,
        height: deviceInfo.localHeight * 0.1,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(deviceInfo.localWidth * 0.04),
          boxShadow: [
            BoxShadow(
              color: ColorsManager.blackColor.withOpacity(0.35),
              blurRadius: deviceInfo.screenWidth * 0.05,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: deviceInfo.localWidth * 0.05,
            vertical: deviceInfo.localHeight * 0.02,
          ),
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                size: deviceInfo.localWidth * 0.07,
                color: ColorsManager.secondaryTextColor,
              ),
              SizedBox(width: deviceInfo.localWidth * 0.03),
              Expanded(
                child: Text(
                  'What’s on your mind?',
                  style: TextStyles.inter16RegularBlack.copyWith(
                    fontSize: deviceInfo.localWidth * 0.04,
                    color: ColorsManager.secondaryTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
