import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/helper/extantions.dart';

import '../../../../../../core/Responsive/Models/device_info.dart'
    show DeviceInfo;
import '../../../../../../core/di/di.dart' show getIt;
import '../../../../../../core/routing/routs.dart';
import '../../../../../../core/shared/widgets/cherryToast/CherryToastMsgs.dart'
    show CherryToastMsgs;
import '../../../../../../core/shared/widgets/custom_dialog_widget.dart';
import '../../../../../../core/theming/colors.dart' show ColorsManager;
import '../../logic/report_details_cubit.dart';

class ActionButtonsWidget extends StatelessWidget {
  final DeviceInfo info;

  const ActionButtonsWidget({super.key, required this.info});

  Future<void> _showReasonDialog(BuildContext context, String action) async {
    final TextEditingController reasonController = TextEditingController();

    await showDialog(
      context: context,
      builder:
          (context) => CustomDialogWidget(
            deviceInfo: info,
            title: "$action Reason",
            fields: [
              _buildTextField(
                controller: reasonController,
                labelText: "Reason",
                hintText: "Enter $action reason",
                maxLines: 2,
              ),
            ],
            actions: [
              _buildDialogButton(
                label: "Cancel",
                onPressed: () {
                  Navigator.pop(context);
                  reasonController.clear();
                },
                backgroundColor: ColorsManager.greyColor.withOpacity(0.2),
                textColor: ColorsManager.blackColor,
              ),
              SizedBox(width: info.localWidth * 0.02),
              _buildDialogButton(
                label: "Submit",
                onPressed: () async {
                  final String reason = reasonController.text.trim();
                  if (reason.isEmpty) {
                    CherryToastMsgs.CherryToastError(
                      info: info,
                      context: context,
                      title: "Invalid Input",
                      description: "Please provide a valid $action reason.",
                    );
                    return;
                  }

                  await getIt<ReportDetailsCubit>().addActionToReport(
                    action,
                    reason,
                  );
                  if (context.mounted) {
                    CherryToastMsgs.CherryToastSuccess(
                      info: info,
                      context: context,
                      title: "$action Successful",
                      description: "$action reason submitted successfully.",
                    );
                    Navigator.pop(context);
                  }
                  if (context.mounted) {
                    context.pushReplacementNamed(Routes.adminReportScreen);
                  }
                  reasonController.clear();
                },
                backgroundColor:
                    action == "APPROVE" ? Colors.green : Colors.red,
                textColor: Colors.white,
              ),
            ],
          ),
    );
  }

  /// Builds a reusable TextField widget.
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    int? maxLines,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        filled: true,
        fillColor: ColorsManager.lightGreyColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(info.localWidth * 0.03),
          borderSide: BorderSide(
            color: ColorsManager.greyColor,
            width: info.localWidth * 0.0015,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(info.localWidth * 0.03),
          borderSide: BorderSide(
            color: ColorsManager.greyColor,
            width: info.localWidth * 0.0015,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(info.localWidth * 0.03),
          borderSide: BorderSide(
            color: ColorsManager.primaryColor,
            width: info.localWidth * 0.0015,
          ),
        ),
      ),
    );
  }

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
            borderRadius: BorderRadius.circular(info.localWidth * 0.03),
          ),
        ),
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: info.localWidth * 0.1,
            vertical: info.localHeight * 0.015,
          ),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: info.screenWidth * 0.04,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () async {
            await context.read<ReportDetailsCubit>().addActionToReport(
              'APPROVE',
              '',
            );
            if (context.mounted) {
              CherryToastMsgs.CherryToastSuccess(
                info: info,
                context: context,
                title: "Approve Successful",
                description: "Report approved successfully.",
              );
            }
            if (context.mounted) {
              context.pushReplacementNamed(Routes.adminReportScreen);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: Size(info.screenWidth * 0.4, info.screenHeight * 0.05),
          ),
          child: Text(
            'Approve',
            style: TextStyle(
              fontSize: info.screenWidth * 0.04,
              color: Colors.white,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await _showReasonDialog(context, 'REJECT');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: Size(info.screenWidth * 0.4, info.screenHeight * 0.05),
          ),
          child: Text(
            'Reject',
            style: TextStyle(
              fontSize: info.screenWidth * 0.04,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
