import 'package:flutter/material.dart';
import 'package:social_mate/core/Responsive/Models/device_info.dart';
import 'package:social_mate/core/di/di.dart';
import 'package:social_mate/core/helper/extantions.dart';
import 'package:social_mate/core/shared/widgets/cherryToast/CherryToastMsgs.dart';
import 'package:social_mate/core/theming/styles.dart';

import '../../routing/routs.dart';
import '../../theming/colors.dart';
import '../../../features/posts/presentation/homePage/logic/cubit/home_cubit_cubit.dart';
import 'custom_dialog_widget.dart';

class ShowCreatePostDialogWidget extends StatelessWidget {
  const ShowCreatePostDialogWidget({super.key, required this.deviceInfo});

  final DeviceInfo deviceInfo;

  @override
  Widget build(BuildContext context) {
    // Define local controllers
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    return CustomDialogWidget(
      deviceInfo: deviceInfo,
      title: "Create Post",
      fields: [
        _buildTextField(
          controller: titleController,
          labelText: "Title",
          hintText: "Enter a title",
          maxLength: 100, // Optional: Limit the title length
        ),
        SizedBox(height: deviceInfo.localHeight * 0.02),
        _buildTextField(
          controller: contentController,
          labelText: "Content",
          hintText: "Enter the content",
          maxLines: 4,
        ),
      ],
      actions: [
        _buildDialogButton(
          label: "Cancel",
          onPressed: () {
            Navigator.pop(context); // Close the dialog
            titleController.clear(); // Clear the controllers
            contentController.clear();
          },
          backgroundColor: ColorsManager.greyColor.withOpacity(0.2),
          textColor: ColorsManager.blackColor,
        ),
        SizedBox(width: deviceInfo.localWidth * 0.02),
        _buildDialogButton(
          label: "Submit",
          onPressed: () async {
            final String title = titleController.text.trim();
            final String content = contentController.text.trim();

            if (title.isEmpty || content.isEmpty) {
              CherryToastMsgs.CherryToastError(
                info: deviceInfo,
                context: context,
                title: "Invalid Input",
                description: "Please enter a title and content.",
              );
              return;
            }

            if (title.length < 25) {
              CherryToastMsgs.CherryToastError(
                info: deviceInfo,
                context: context,
                title: "Invalid Title",
                description: "Title must be at least 25 characters.",
              );
              return;
            }
            CherryToastMsgs.CherryToastSuccess(
              info: deviceInfo,
              context: context,
              title: "post created",
              description: "post created successfully.",
            );
            await getIt.get<HomeCubit>().createPost(title, content);
            if (context.mounted) {
              context.pushReplacementNamed(Routes.homePage);
            }
            titleController.clear();
            contentController.clear();
          },
          backgroundColor: ColorsManager.primaryColor,
          textColor: Colors.white,
        ),
      ],
    );
  }

  /// Builds a reusable TextField widget.
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    int? maxLength,
    int? maxLines,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines ?? 1,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelStyle: TextStyles.inter14RegularBlue,
        labelText: labelText,
        hintText: hintText,
        filled: true,
        fillColor: ColorsManager.lightGreyColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(deviceInfo.localWidth * 0.03),
          borderSide: BorderSide(
            color: ColorsManager.greyColor,
            width: deviceInfo.localWidth * 0.0015,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(deviceInfo.localWidth * 0.03),
          borderSide: BorderSide(
            color: ColorsManager.greyColor,
            width: deviceInfo.localWidth * 0.0015,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(deviceInfo.localWidth * 0.03),
          borderSide: BorderSide(
            color: ColorsManager.primaryColor,
            width: deviceInfo.localWidth * 0.0015,
          ),
        ),
      ),
    );
  }

  /// Builds a reusable button for the dialog actions.
  Widget _buildDialogButton({
    required String label,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(deviceInfo.localWidth * 0.03),
          ),
        ),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: deviceInfo.localWidth * 0.1,
            vertical: deviceInfo.localHeight * 0.015,
          ),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: deviceInfo.screenWidth * 0.04,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
