import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/helper/extantions.dart';
import '../../../../../../core/Responsive/Models/device_info.dart';
import '../../../../../../core/routing/routs.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/styles.dart';
import '../../logic/report_details_cubit.dart';

class RelatedReportWidget extends StatelessWidget {
  const RelatedReportWidget({
    super.key,
    required this.deviceInfo,
    required this.reportId,
    required this.fullName,
    required this.createdAt,
    required this.state,
  });

  final DeviceInfo deviceInfo;
  final int reportId;
  final String fullName;
  final String createdAt;
  final String state;

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
    return Semantics(
      label:
          'Related Report by $fullName, Created at $createdAt, State: $state',
      child: InkWell(
        onTap: () {
          ReportDetailsCubit.setSelectedReport(reportId);
          context.read<ReportDetailsCubit>().getReportDetails();
          context.pushNamed(Routes.adminReportScreen);
        },
        splashColor: ColorsManager.orangeColor.withOpacity(0.3),
        highlightColor: ColorsManager.orangeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(deviceInfo.screenWidth * 0.03),
        child: Container(
          width: deviceInfo.screenWidth * 0.9,
          padding: EdgeInsets.all(deviceInfo.screenWidth * 0.03),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(deviceInfo.screenWidth * 0.03),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: deviceInfo.screenWidth * 0.01,
                blurRadius: deviceInfo.screenWidth * 0.02,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  fullName,
                  style: TextStyles.inter18BoldBlack.copyWith(
                    fontSize: deviceInfo.screenWidth * 0.03,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: deviceInfo.screenWidth * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      deviceInfo.screenWidth * 0.03,
                    ),
                    color: getStateColor(state),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      deviceInfo.screenWidth * 0.032,
                      deviceInfo.screenWidth * 0.01,
                      deviceInfo.screenWidth * 0.02,
                      deviceInfo.screenWidth * 0.01,
                    ),
                    child: Text(
                      state,
                      style: TextStyles.inter18BoldBlack.copyWith(
                        fontSize: deviceInfo.screenWidth * 0.03,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    createdAt,
                    style: TextStyles.inter18BoldBlack.copyWith(
                      fontSize: deviceInfo.screenWidth * 0.03,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
