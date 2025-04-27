import 'package:flutter/material.dart';

import '../../../../core/Responsive/ui_component/info_widget.dart';
import 'widgets/on_board_model.dart';

class OnboardContent extends StatelessWidget {
  final OnboardModel page;

  const OnboardContent({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return InfoWidget(
      builder: (context, info) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(page.image, height: info.screenHeight * 0.4),

            Text(
              page.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: info.screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            Text(
              page.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: info.screenWidth * 0.04,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        );
      },
    );
  }
}
