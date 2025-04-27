import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/helper/extantions.dart';
import 'package:social_mate/core/shared/widgets/Shimmer/ShimmerStyle.dart';
import 'package:social_mate/core/shared/widgets/build_category_selection_field.dart';
import 'package:social_mate/core/shared/widgets/cherryToast/CherryToastMsgs.dart';
import 'package:social_mate/core/theming/styles.dart';
import 'package:social_mate/features/admin/data/models/main_report_model.dart';

import '../../../features/posts/presentation/homePage/logic/cubit/home_cubit_cubit.dart';
import '../../../features/posts/presentation/homePage/ui/widgets/build_error_widget.dart';
import '../../Responsive/Models/device_info.dart';
import '../../theming/colors.dart';
import 'custom_dialog_widget.dart';

// ignore: must_be_immutable
class ShowReportPostDialogWidget extends StatefulWidget {
  const ShowReportPostDialogWidget({
    super.key,
    required this.deviceInfo,
    this.onPressedReport,
  });

  final DeviceInfo deviceInfo;
  final Function(int categoryId, String reason)? onPressedReport;

  @override
  State<ShowReportPostDialogWidget> createState() =>
      _ShowReportPostDialogWidgetState();
}

class _ShowReportPostDialogWidgetState
    extends State<ShowReportPostDialogWidget> {
  int selectedCategory = -1;
  late final TextEditingController reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is PostReported) {
          // Future.delayed( Duration(seconds: 2), () => Navigator.pop(context));
          CherryToastMsgs.CherryToastSuccess(
            info: widget.deviceInfo,
            context: context,
            title: 'Success',
            description: 'Your report has been sent successfully.',
          );
        }
      },
      builder: (context, state) {
        if (state is LoadedReportCategories) {
          return _buildReportDialog(context, state.categories);
        } else if (state is PostReportedLoading) {
          return _buildShimmerEffect(); // Display shimmer effect while loading
        } else {
          return BuildErrorWidget(
            deviceInfo: widget.deviceInfo,
            message: "Something went wrong",
          );
        }
      },
    );
  }

  Widget _buildShimmerEffect() {
    return CustomDialogWidget(
      deviceInfo: widget.deviceInfo,
      title: "Report the Post",
      fields: [
        customShimmer(
          childWidget: Container(
            height: widget.deviceInfo.localHeight * 0.1,
            width: double.infinity,
            color: Colors.grey.shade300,
          ),
        ),
        SizedBox(height: widget.deviceInfo.localHeight * 0.02),
        customShimmer(
          childWidget: Container(
            height: widget.deviceInfo.localHeight * 0.15,
            width: double.infinity,
            color: Colors.grey.shade300,
          ),
        ),
      ],
      actions: [],
    );
  }

  Widget _buildReportDialog(BuildContext context, List<Category> categories) {
    return CustomDialogWidget(
      deviceInfo: widget.deviceInfo,
      title: "Report the Post",
      fields: [
        CategorySelectionField(
          deviceInfo: widget.deviceInfo,
          categories: categories,
          onCategorySelected: (index) {
            setState(() {
              selectedCategory = index;
            });
          },
        ),
        SizedBox(height: widget.deviceInfo.localHeight * 0.02),
        _buildReasonTextField(widget.deviceInfo, reasonController),
      ],
      actions: [
        _buildReportButton(widget.deviceInfo, () async {
          if (selectedCategory == -1) {
            CherryToastMsgs.CherryToastError(
              info: widget.deviceInfo,
              context: context,
              title: 'Error',
              description: 'Please select a category.',
            );
          } else if (reasonController.text.isEmpty) {
            CherryToastMsgs.CherryToastError(
              info: widget.deviceInfo,
              context: context,
              title: 'Error',
              description: 'Please provide a reason for the report.',
            );
          } else {
            CherryToastMsgs.CherryToastSuccess(
              info: widget.deviceInfo,
              context: context,
              title: 'Report Sent',
              description: 'Your report has been sent successfully.',
            );
            await widget.onPressedReport!(
              categories[selectedCategory].id,
              reasonController.text,
            );
          }
        }),
        SizedBox(width: widget.deviceInfo.localWidth * 0.02),
        _buildCancelButton(widget.deviceInfo, context),
      ],
    );
  }

  Widget _buildReasonTextField(
    DeviceInfo deviceInfo,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: "Provide a Reason",
        labelStyle: TextStyles.inter14RegularBlue,
        filled: true,
        fillColor: ColorsManager.lightGreyColor,
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
            width: deviceInfo.localWidth * 0.002,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(deviceInfo.localWidth * 0.03),
          borderSide: BorderSide(
            color: ColorsManager.greyColor,
            width: deviceInfo.localWidth * 0.0015,
          ),
        ),
      ),
    );
  }

  Widget _buildReportButton(DeviceInfo deviceInfo, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(ColorsManager.redColor),
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
        "Report",
        style: TextStyle(
          color: Colors.white,
          fontSize: deviceInfo.screenWidth * 0.04,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCancelButton(DeviceInfo deviceInfo, BuildContext context) {
    return TextButton(
      onPressed: () {
        context.pop();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          ColorsManager.greyColor.withOpacity(0.3),
        ),
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
        "Cancel",
        style: TextStyle(
          color: ColorsManager.blackColor,
          fontSize: deviceInfo.screenWidth * 0.04,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }
}
