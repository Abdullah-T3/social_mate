import 'package:flutter/material.dart';
import 'package:social_mate/core/helper/extantions.dart';

import '../../Responsive/Models/device_info.dart';
import '../../di/di.dart';
import '../../routing/routs.dart';
import '../../theming/colors.dart';
import '../../theming/styles.dart';
import '../../userMainDetails/userMainDetails_cubit.dart';

void logOutDialog(BuildContext context, DeviceInfo deviceInfo) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          backgroundColor: ColorsManager.whiteColor,
          title: Text(
            'Confirm Logout',
            style: TextStyles.inter18BoldBlack.copyWith(
              fontSize: deviceInfo.screenWidth * 0.05,
            ),
          ),
          content: Text(
            'Are you sure you want to log out?',
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
                context.pushNamedAndRemoveUntil(
                  Routes.AuthScreen,
                  predicate: (route) => false,
                );
                getIt<userMainDetailsCubit>().logOut();
              },
              child: Text(
                'Logout',
                style: TextStyles.inter18Regularblack.copyWith(
                  color: ColorsManager.redColor,
                ),
              ),
            ),
          ],
        ),
  );
}
