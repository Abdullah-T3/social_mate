import 'package:flutter/material.dart';
import '../../../../../../core/Responsive/Models/device_info.dart';
import '../../../../../../core/theming/colors.dart';

// ignore: must_be_immutable
class ReportDialogMarwan extends StatelessWidget {
  ReportDialogMarwan({super.key, required this.deviceInfo});
  final DeviceInfo deviceInfo;
  int selectedCategory = -1;
  final TextEditingController reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(deviceInfo.screenWidth * 0.03),
      ),
      elevation: 8.0,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(deviceInfo.screenWidth * 0.05),
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Ensures dialog does not expand unnecessarily
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                "Report the Post",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: deviceInfo.screenWidth * 0.05,
                  color: ColorsManager.blackColor,
                ),
              ),
              SizedBox(height: deviceInfo.screenHeight * 0.02),

              // Category Selection
              Text(
                "Select a Category",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: deviceInfo.screenWidth * 0.04,
                  color: ColorsManager.greyColor,
                ),
              ),
              SizedBox(height: deviceInfo.screenHeight * 0.01),

              // Radio Button Selection
              StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    children: List.generate(
                      4,
                      (index) => InkWell(
                        onTap: () {
                          setState(() {
                            selectedCategory = index;
                          });
                        },
                        child: Row(
                          children: [
                            Radio<int>(
                              value: index,
                              groupValue: selectedCategory,
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value!;
                                });
                              },
                              activeColor: ColorsManager.primaryColor,
                            ),
                            SizedBox(width: deviceInfo.screenWidth * 0.02),
                            Expanded(
                              child: Text(
                                [
                                  "Harmful",
                                  "Inappropriate",
                                  "Spam",
                                  "Other"
                                ][index],
                                style: TextStyle(
                                  fontSize: deviceInfo.screenWidth * 0.04,
                                  color: ColorsManager.blackColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: deviceInfo.screenHeight * 0.02),

              // Reason TextField
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Provide a Reason",
                  filled: true,
                  fillColor: ColorsManager.lightGreyColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(deviceInfo.screenWidth * 0.03),
                    borderSide: BorderSide(
                      color: ColorsManager.greyColor,
                      width: deviceInfo.screenWidth * 0.0015,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(deviceInfo.screenWidth * 0.03),
                    borderSide: BorderSide(
                      color: ColorsManager.primaryColor,
                      width: deviceInfo.screenWidth * 0.002,
                    ),
                  ),
                ),
              ),
              SizedBox(height: deviceInfo.screenHeight * 0.03),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Cancel Button
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          ColorsManager.greyColor.withOpacity(0.3)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              deviceInfo.screenWidth * 0.03),
                        ),
                      ),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(
                          horizontal: deviceInfo.screenWidth * 0.1,
                          vertical: deviceInfo.screenHeight * 0.015,
                        ),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: ColorsManager.blackColor,
                        fontSize: deviceInfo.screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: deviceInfo.screenWidth * 0.02),

                  // Report Button
                  TextButton(
                    onPressed: () {
                      if (selectedCategory != -1 &&
                          reasonController.text.isNotEmpty) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Post reported successfully!")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  "Please select a category and provide a reason.")),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(ColorsManager.redColor),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              deviceInfo.screenWidth * 0.03),
                        ),
                      ),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(
                          horizontal: deviceInfo.screenWidth * 0.1,
                          vertical: deviceInfo.screenHeight * 0.015,
                        ),
                      ),
                    ),
                    child: Text(
                      "Report",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: deviceInfo.screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
