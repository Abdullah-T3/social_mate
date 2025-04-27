import 'package:flutter/material.dart';

import '../../../features/admin/data/models/main_report_model.dart';
import '../../Responsive/Models/device_info.dart';
import '../../theming/colors.dart';

class CategorySelectionField extends StatefulWidget {
  final DeviceInfo deviceInfo;
  final List<Category> categories;
  final ValueChanged<int> onCategorySelected;

  const CategorySelectionField({
    super.key,
    required this.deviceInfo,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CategorySelectionFieldState createState() => _CategorySelectionFieldState();
}

class _CategorySelectionFieldState extends State<CategorySelectionField> {
  int _selectedCategory = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select a Category",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: widget.deviceInfo.screenWidth * 0.04,
            color: ColorsManager.greyColor,
          ),
        ),
        SizedBox(height: widget.deviceInfo.localHeight * 0.01),
        Column(
          children: List.generate(
            widget.categories.length,
            (index) => Padding(
              padding: EdgeInsets.symmetric(
                vertical: widget.deviceInfo.localHeight * 0.01,
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedCategory = index;
                    widget.onCategorySelected(index); // Notify parent
                  });
                },
                child: Row(
                  children: [
                    Radio<int>(
                      value: index,
                      groupValue: _selectedCategory,
                      onChanged: (_) {
                        setState(() {
                          _selectedCategory = index;
                          widget.onCategorySelected(index); // Notify parent
                        });
                      },
                      activeColor: ColorsManager.primaryColor,
                    ),
                    SizedBox(width: widget.deviceInfo.localWidth * 0.02),
                    Expanded(
                      child: Text(
                        widget.categories[index].titleEn.toString(),
                        style: TextStyle(
                          fontSize: widget.deviceInfo.screenWidth * 0.04,
                          color: ColorsManager.blackColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
