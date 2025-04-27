import 'package:flutter/material.dart';

import '../../../../../core/Responsive/Models/device_info.dart';
import '../../../../../core/di/di.dart' show getIt;
import '../../../../../core/theming/colors.dart' show ColorsManager;
import '../../../../../core/theming/styles.dart';
import '../../../../posts/presentation/homePage/logic/cubit/home_cubit_cubit.dart'
    show HomeCubit;

void deleteDialog(BuildContext context, int postId, DeviceInfo deviceInfo) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
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
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                if (postId == 0) {
                  return;
                }
                getIt.get<HomeCubit>().deletePost(postId);
              },
              child: Text(
                'Delete',
                style: TextStyles.inter18Regularblack.copyWith(
                  color: ColorsManager.redColor,
                ),
              ),
            ),
          ],
        ),
  );
}
