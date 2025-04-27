import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/helper/extantions.dart';
import 'package:social_mate/features/admin/presentation/report_details/ui/widgets/related_report_widget.dart'
    show RelatedReportWidget;
import 'package:social_mate/features/admin/presentation/report_details/ui/widgets/report_detials_widget.dart';

import '../../../../../core/Responsive/Models/device_info.dart';
import '../../../../../core/Responsive/ui_component/info_widget.dart'
    show InfoWidget;
import '../../../../../core/routing/routs.dart';
import '../../../../../core/shared/widgets/animation/slide_Transition__widget.dart';
import '../../../../../core/shared/widgets/header_widget.dart';
import '../../../../../core/shared/widgets/postDetailsPostCard.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/styles.dart';
import '../../../../posts/presentation/homePage/ui/widgets/build_error_widget.dart';
import '../../../../posts/presentation/postDetails/presentation/logic/post_details_cubit.dart';
import '../../../data/models/main_report_model.dart';
import '../logic/report_details_cubit.dart';

class ReportDetailsScreen extends StatefulWidget {
  const ReportDetailsScreen({super.key});

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportDetailsCubit>().getReportDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return InfoWidget(
      builder: (context, info) {
        return SafeArea(
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                _buildHeader(info),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: info.screenWidth * 0.05,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Report details",
                          style: TextStyles.inter18BoldBlack.copyWith(
                            fontSize: info.screenWidth * 0.046,
                          ),
                        ),
                        Divider(
                          thickness: 2,
                          height: info.screenHeight * 0.02,
                          color: ColorsManager.blackColor.withOpacity(0.6),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: info.screenHeight * 0.02),
                ),
                _buildReportDetailsSection(info),
                SliverToBoxAdapter(
                  child: SizedBox(height: info.screenHeight * 0.02),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: info.screenWidth * 0.05,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Post details",
                          style: TextStyles.inter18BoldBlack.copyWith(
                            fontSize: info.screenWidth * 0.046,
                          ),
                        ),
                        Divider(
                          thickness: 2,
                          height: info.screenHeight * 0.02,
                          color: ColorsManager.blackColor.withOpacity(0.6),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildPostDetailsSection(info),
                SliverToBoxAdapter(
                  child: SizedBox(height: info.screenHeight * 0.02),
                ),
                _buildRelatedReportsSection(info),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds the header section with back button and title image.
  SliverToBoxAdapter _buildHeader(DeviceInfo info) {
    return SliverToBoxAdapter(
      child: HeaderWidget(
        isAdmin: false,
        isUser: false,
        extraButtons: [],
        isBackButtonVisible: true,
        info: info,
        onBackPressed: () => context.pop(),
        titleImageAsset: 'assets/images/Title_img.png',
      ),
    );
  }

  /// Builds the report details section.
  SliverToBoxAdapter _buildReportDetailsSection(DeviceInfo info) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: info.screenWidth * 0.05),
        child: BlocBuilder<ReportDetailsCubit, ReportDetailsState>(
          builder: (context, state) {
            if (state is ReportDetailsLoading) {
              return ReportDetialsWidget(
                info: info,
                isLoading: true,
                createdOn: '',
                reportedBy: '',
                lastModifiedBy: '',
                status: '',
                reportReason: '',
                lastModifiedOn: '',
                category: '',
              );
            } else if (state is ReportDetailsError) {
              return BuildErrorWidget(deviceInfo: info, message: state.message);
            } else if (state is ReportDetailsLoaded) {
              return ReportDetialsWidget(
                info: info,
                createdOn: state.report.reportDetails.createdOn,
                reportedBy: state.report.reportDetails.createdBy.fullName,
                lastModifiedBy:
                    state.report.reportDetails.lastModifiedBy.fullName,
                status: state.report.reportDetails.status.titleEn,
                reportReason: state.report.reportDetails.reason,
                lastModifiedOn: state.report.reportDetails.lastModifiedOn,
                category: state.report.reportDetails.category.titleEn,
              );
            }
            return const SizedBox.shrink(); // Placeholder for initial state
          },
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildPostDetailsSection(DeviceInfo info) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: info.screenWidth * 0.05),
        child: BlocBuilder<ReportDetailsCubit, ReportDetailsState>(
          builder: (context, state) {
            bool isLoading =
                state is ReportDetailsLoading ||
                state is CommentsCountRepLoading ||
                state is GetAvrageRatingLoading;
            if (isLoading) {
              return SlideTransitionWidget(
                child: Column(
                  children: [
                    Text(
                      "Post Details",
                      style: TextStyles.inter18BoldBlack.copyWith(
                        fontSize: info.screenWidth * 0.045,
                      ),
                    ),
                    PostDetailsPostCard(
                      titleText: '',
                      contentText: '',
                      fullNameText: '',
                      commentsCountText: '',
                      rateAverageText: '',
                      formattedDateText: '',
                      SelectedRatingValue: 5,
                      info: info,
                      showStars: false,
                      isTitleShimmer: true,
                      isNameAndDateShimmer: true,
                      isContentShimmer: true,
                      isCommentsCountShimmer: true,
                      isRateAverageShimmer: true,
                      disableStars: true,
                      showDeleteButton: false,
                      showReportButton: false,
                    ),
                  ],
                ),
              );
            }
            if (state is ReportDetailsLoaded) {
              final reportState = context.read<ReportDetailsCubit>().state;
              final report =
                  (reportState is ReportDetailsLoaded)
                      ? reportState.report.reportDetails.post
                      : null;
              return SlideTransitionWidget(
                child: InkWell(
                  onTap: () {
                    PostDetailsCubit.setSelectedPost(report.id);
                    context.pushNamed(Routes.postDetailsScreen);
                  },
                  child: PostDetailsPostCard(
                    info: info,
                    showStars: false,
                    titleText: report!.title,
                    fullNameText: report.createdBy.fullName,
                    formattedDateText: report.createdOn,
                    contentText: report.content,
                    commentsCountText: 'Comments ${state.commentsCount}',
                    rateAverageText:
                        'Rate ${state.avrageRating.toStringAsFixed(1)}', // Format rating to 1 decimal place
                    SelectedRatingValue: 5,
                    disableStars: true,
                    isTitleShimmer: false,
                    showDeleteButton: false,
                    isNameAndDateShimmer: false,
                    showReportButton: false,
                    isContentShimmer: false,
                    isCommentsCountShimmer: false,
                    isRateAverageShimmer: false,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /// Builds the related reports section.
  Widget _buildRelatedReportsSection(DeviceInfo info) {
    return BlocBuilder<ReportDetailsCubit, ReportDetailsState>(
      builder: (context, state) {
        if (state is ReportDetailsLoaded) {
          return SliverPadding(
            padding: EdgeInsets.all(info.screenWidth * 0.03),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'Related Reports',
                  style: TextStyles.inter18BoldBlack.copyWith(
                    fontSize: info.screenWidth * 0.045,
                  ),
                ),
                Divider(
                  thickness: 2,
                  height: info.screenHeight * 0.02,
                  color: ColorsManager.blackColor.withOpacity(0.6),
                ),
                SizedBox(height: info.screenHeight * 0.02),
                ..._buildScrollableRelatedReportsList(
                  info,
                  state.report.relatedReports,
                ),
              ]),
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  /// Builds the scrollable list of related reports as a list of widgets.
  List<Widget> _buildScrollableRelatedReportsList(
    DeviceInfo info,
    List<RelatedReport> relatedReports,
  ) {
    return relatedReports.map((report) {
      return Column(
        children: [
          RelatedReportWidget(
            reportId: report.id,
            deviceInfo: info,
            fullName: report.createdBy.fullName,
            createdAt: report.category.titleEn,
            state: report.status.titleEn,
          ),
          if (relatedReports.indexOf(report) != relatedReports.length - 1)
            SizedBox(height: info.screenHeight * 0.02),
        ],
      );
    }).toList();
  }
}
