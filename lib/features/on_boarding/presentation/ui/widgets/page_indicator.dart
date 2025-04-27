import 'package:flutter/material.dart';

import '../../../../../core/Responsive/ui_component/info_widget.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return InfoWidget(
      builder: (context, info) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            pageCount,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: info.screenWidth * 0.01),
              height: info.screenHeight * 0.01,
              width: currentPage == index ? 24 : 8,
              decoration: BoxDecoration(
                color:
                    currentPage == index
                        ? Colors.blueAccent
                        : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(info.screenWidth * 0.01),
              ),
            ),
          ),
        );
      },
    );
  }
}
