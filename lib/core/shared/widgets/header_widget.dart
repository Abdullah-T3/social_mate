import 'package:flutter/material.dart';
import 'package:social_mate/core/helper/extantions.dart';

import '../../Responsive/Models/device_info.dart';
import '../../routing/routs.dart';
import '../../theming/colors.dart';

class HeaderWidget extends StatelessWidget {
  final DeviceInfo info;
  final VoidCallback onBackPressed;
  final String titleImageAsset;
  final List<Widget> extraButtons;
  final bool isBackButtonVisible;
  final bool isAdmin;
  final bool isUser;
  final String searchIconRoute;

  const HeaderWidget({
    super.key,
    required this.info,
    required this.onBackPressed,
    required this.titleImageAsset,
    this.extraButtons = const [],
    required this.isBackButtonVisible,
    required this.isAdmin,
    required this.isUser,
    this.searchIconRoute = Routes.filteringScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: info.screenWidth * 0.02,
        vertical: info.screenHeight * 0.01,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: info.screenWidth * 0.01,
        children: [
          if (isBackButtonVisible)
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: info.screenWidth * 0.08,
                color: ColorsManager.primaryColor,
              ),
              onPressed: onBackPressed,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: EdgeInsets.all(info.screenWidth * 0.01),
                backgroundColor: ColorsManager.lightGreyColor,
                shadowColor: Colors.transparent,
              ),
            ),

          Image.asset(
            titleImageAsset,
            width: info.screenWidth * 0.48,
            height: info.screenHeight * 0.06,
            fit: BoxFit.contain,
          ),

          const Spacer(), // Pushes buttons to the right

          if (isAdmin && isUser)
            Row(
              children: [
                IconButton(
                  onPressed: () => context.pushNamed(searchIconRoute),
                  icon: Icon(Icons.search),
                  iconSize: info.screenWidth * 0.08,
                  color: ColorsManager.primaryColor,
                ),
                IconButton(
                  icon: Icon(
                    Icons.menu,
                    size: info.screenWidth * 0.08,
                    color: ColorsManager.primaryColor,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
              ],
            )
          else
            Row(mainAxisSize: MainAxisSize.min, children: extraButtons),
        ],
      ),
    );
  }
}
