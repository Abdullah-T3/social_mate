import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/features/admin/presentation/report_details/logic/report_details_cubit.dart';
import 'package:social_mate/features/admin/presentation/report_details/ui/widgets/build_action_buttons_widget.dart'
    show ActionButtonsWidget;

import '../../../../../../core/Responsive/Models/device_info.dart'
    show DeviceInfo;
import '../../../../../../core/di/di.dart';
import '../../../../../../core/shared/widgets/Shimmer/ShimmerStyle.dart';
import '../../../../../../core/shared/widgets/animation/slide_Transition__widget.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/styles.dart';

class ReportDetialsWidget extends StatelessWidget {
  final DeviceInfo info;
  final String category;
  final String status;
  final String reportedBy;
  final String reportReason;
  final String createdOn;
  final String? lastModifiedOn;
  final String lastModifiedBy;
  final bool isLoading;

  const ReportDetialsWidget({
    super.key,
    required this.info,
    required this.category,
    required this.status,
    required this.reportedBy,
    required this.reportReason,
    required this.createdOn,
    this.lastModifiedOn,
    required this.lastModifiedBy,
    this.isLoading = false,
  });
  Color getStateColor(String state) {
    switch (state.toLowerCase()) {
      case 'approved' || 'cascaded approval':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return ColorsManager.orangeColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      width: info.screenWidth * 0.9,
      padding: EdgeInsets.all(info.screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: info.screenWidth * 0.01,
            blurRadius: info.screenWidth * 0.02,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(info.screenWidth * 0.03),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: info.screenHeight * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: info.screenWidth * 0.4,
                  decoration: BoxDecoration(
                    color: ColorsManager.lightGreyColor,
                    borderRadius: BorderRadius.circular(
                      info.screenWidth * 0.02,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: info.screenWidth * 0.01,
                        blurRadius: info.screenWidth * 0.02,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      category,
                      style: TextStyles.inter18BoldBlack.copyWith(
                        fontSize: info.screenWidth * 0.04,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: info.screenWidth * 0.4,
                  decoration: BoxDecoration(
                    color: getStateColor(status),
                    borderRadius: BorderRadius.circular(
                      info.screenWidth * 0.02,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: info.screenWidth * 0.01,
                        blurRadius: info.screenWidth * 0.02,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      status,
                      style: TextStyles.inter18BoldBlack.copyWith(
                        fontSize: info.screenWidth * 0.04,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: info.screenHeight * 0.02),
            Row(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: ColorsManager.lightGreyColor,
                    borderRadius: BorderRadius.circular(
                      info.screenWidth * 0.02,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: info.screenWidth * 0.02,
                    ),
                    child: Text(
                      'Reported By: $reportedBy',
                      style: TextStyles.inter18RegularWithOpacity.copyWith(
                        fontSize: info.screenWidth * 0.036,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  createdOn,
                  style: TextStyles.inter18RegularWithOpacity.copyWith(
                    fontSize: info.screenWidth * 0.026,
                  ),
                ),
              ],
            ),
            SizedBox(height: info.screenHeight * 0.01),
            Text(
              "Report Reason:",
              style: TextStyles.inter18Bold.copyWith(
                fontSize: info.screenWidth * 0.044,
              ),
            ),
            Divider(
              thickness: 2,
              height: info.screenHeight * 0.02,
              color: ColorsManager.blackColor.withOpacity(0.6),
            ),
            Text(
              reportReason,
              style: TextStyles.inter18RegularWithOpacity.copyWith(
                fontSize: info.screenWidth * 0.04,
              ),
            ),
            SizedBox(height: info.screenHeight * 0.02),
            Text(
              "Actions",
              style: TextStyles.inter18Bold.copyWith(
                fontSize: info.screenWidth * 0.044,
              ),
            ),
            Divider(
              thickness: 2,
              height: info.screenHeight * 0.02,
              color: ColorsManager.blackColor.withOpacity(0.6),
            ),
            lastModifiedBy.isEmpty
                ? Container()
                : Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Admin: ',
                            style: TextStyles.inter18BoldBlack.copyWith(
                              fontSize: info.screenWidth * 0.04,
                            ),
                          ),
                          TextSpan(
                            text: lastModifiedBy,
                            style: TextStyles.inter18RegularWithOpacity
                                .copyWith(fontSize: info.screenWidth * 0.045),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Text(
                      lastModifiedOn ?? '',
                      style: TextStyles.inter18RegularWithOpacity.copyWith(
                        fontSize: info.screenWidth * 0.045,
                      ),
                    ),
                  ],
                ),
            SizedBox(height: info.screenHeight * 0.02),
            lastModifiedBy.isEmpty
                ? BlocProvider(
                  create: (context) => getIt<ReportDetailsCubit>(),
                  child: ActionButtonsWidget(info: info),
                )
                : Container(),
          ],
        ),
      ),
    );

    return SlideTransitionWidget(
      child: isLoading ? customShimmer(childWidget: child) : child,
    );
  }
}
