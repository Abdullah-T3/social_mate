import 'package:flutter/material.dart';

import '../../../../core/theming/colors.dart' show ColorsManager;

class FilteringButton extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final VoidCallback onPressed;
  const FilteringButton({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          Size(screenWidth, screenHeight * 0.01),
        ),
        backgroundColor: MaterialStateProperty.all(ColorsManager.primaryColor),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.009,
          ),
        ),
      ),
      child: Text(
        'Filter',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
