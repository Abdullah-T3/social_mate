import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:social_mate/core/shared/widgets/Shimmer/ShimmerStyle.dart';
import 'package:social_mate/core/theming/colors.dart';
import 'package:social_mate/core/theming/styles.dart';

import '../../Responsive/Models/device_info.dart';

class PostDetailsPostCard extends StatelessWidget {
  const PostDetailsPostCard({
    super.key,
    required this.info,
    required this.titleText,
    required this.isTitleShimmer,
    required this.showDeleteButton,
    this.DeleteButtonOnPressed,
    required this.isNameAndDateShimmer,
    required this.fullNameText,
    required this.formattedDateText,
    required this.showReportButton,
    this.ReportButtonOnPressed,
    required this.isContentShimmer,
    required this.contentText,
    required this.isCommentsCountShimmer,
    required this.commentsCountText,
    required this.isRateAverageShimmer,
    required this.rateAverageText,
    this.showStars = true,
    this.disableStars = false,
    required this.SelectedRatingValue,
    this.setRateAverage,
  });
  final DeviceInfo info;
  final String? titleText;
  final bool isTitleShimmer;
  final bool showDeleteButton;
  final Function()? DeleteButtonOnPressed;
  final bool isNameAndDateShimmer;
  final String? fullNameText;
  final String? formattedDateText;
  final bool showReportButton;
  final Function()? ReportButtonOnPressed;
  final bool isContentShimmer;
  final String? contentText;
  final bool isCommentsCountShimmer;
  final String? commentsCountText;
  final bool isRateAverageShimmer;
  final String? rateAverageText;
  final bool showStars;
  final bool disableStars;
  final double? SelectedRatingValue;
  final Function(int)? setRateAverage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.none,
      constraints: BoxConstraints(minHeight: info.screenHeight * 0.25),
      padding: EdgeInsetsDirectional.only(
        start: info.screenWidth * 0.05,
        end: info.screenWidth * 0.02,
      ),
      decoration: BoxDecoration(
        color: ColorsManager.whiteColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(info.screenWidth * 0.04),
          bottomRight: Radius.circular(info.screenWidth * 0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.blackColor.withOpacity(0.35),
            blurRadius: info.screenWidth * 0.04,
            spreadRadius: info.screenWidth * 0.0001,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: info.screenHeight * 0.053,
                child:
                    // state is PostDetailsLoading || state is PostDetailsInitial
                    isTitleShimmer
                        ? customShimmer(
                          childWidget: Row(
                            children: [
                              Container(
                                width: info.screenWidth * 0.4,
                                height: info.screenHeight * 0.03,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    info.screenWidth * 0.04,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: info.screenWidth * 0.09,
                                height: info.screenHeight * 0.04,
                                margin: EdgeInsetsDirectional.only(
                                  start: info.screenWidth * 0.02,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    info.screenWidth * 0.09,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        : Row(
                          children: [
                            Expanded(
                              child: Text(
                                titleText.toString(),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: TextStyles.inter18BoldBlack.copyWith(
                                  fontSize: info.screenWidth * 0.042,
                                ),
                              ),
                            ),

                            // if (userMainDetails.state.userId == postDetailsCubit.post.createdBy!.id)
                            if (showDeleteButton)
                              IconButton(
                                onPressed: DeleteButtonOnPressed,
                                icon: Icon(
                                  Icons.close,
                                  color: ColorsManager.redColor.withOpacity(
                                    0.7,
                                  ),
                                  size: info.screenWidth * 0.065,
                                ),
                              ),
                          ],
                        ),
              ),
              Divider(
                color: Colors.black,
                thickness: info.screenWidth * 0.002,
                height: info.screenHeight * 0.015,
              ),
              // state is PostDetailsLoading || state is PostDetailsInitial
              isNameAndDateShimmer
                  ? customShimmer(
                    childWidget: Column(
                      spacing: info.screenHeight * 0.01,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: info.screenWidth * 0.27,
                          height: info.screenHeight * 0.023,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              info.screenWidth * 0.09,
                            ),
                          ),
                        ),
                        Container(
                          width: info.screenWidth * 0.22,
                          height: info.screenHeight * 0.018,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              info.screenWidth * 0.09,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                          start: info.screenWidth * 0.015,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fullNameText.toString(),
                              style: TextStyles.inter18BoldBlack.copyWith(
                                fontSize: info.screenWidth * 0.04,
                              ),
                            ),
                            Text(
                              formattedDateText.toString(),
                              style: TextStyles.inter18Regularblack.copyWith(
                                fontSize: info.screenWidth * 0.03,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (showReportButton)
                        IconButton(
                          onPressed: ReportButtonOnPressed,
                          icon: Icon(
                            Icons.flag,
                            color: ColorsManager.redColor.withOpacity(0.7),
                            size: info.screenWidth * 0.065,
                          ),
                        ),
                    ],
                  ),
              Container(
                width: double.infinity,
                padding: EdgeInsetsDirectional.only(
                  start: info.screenWidth * 0.057,
                  end: info.screenWidth * 0.02,
                  bottom: info.screenHeight * 0.01,
                ),
                child:
                    // state is PostDetailsLoading || state is PostDetailsInitial
                    isContentShimmer
                        ? customShimmer(
                          childWidget: Column(
                            spacing: info.screenHeight * 0.01,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsetsDirectional.only(
                                  top: info.screenHeight * 0.02,
                                ),
                                width: info.screenWidth * 0.75,
                                height: info.screenHeight * 0.022,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    info.screenWidth * 0.025,
                                  ),
                                ),
                              ),
                              Container(
                                width: info.screenWidth * 0.6,
                                height: info.screenHeight * 0.017,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    info.screenWidth * 0.03,
                                  ),
                                ),
                              ),
                              Container(
                                width: info.screenWidth * 0.7,
                                height: info.screenHeight * 0.02,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    info.screenWidth * 0.025,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        : Text(
                          contentText.toString(),
                          textAlign: TextAlign.start,
                          softWrap: true,
                          style: TextStyles.inter18RegularWithOpacity.copyWith(
                            fontSize: info.screenWidth * 0.038,
                            color: ColorsManager.blackColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
              ),
            ],
          ),
          Column(
            children: [
              Divider(
                color: Colors.black,
                thickness: info.screenWidth * 0.001,
                height: info.screenHeight * 0.0061,
              ),
              Row(
                children: [
                  // postDetailsCubit.commentsCount == null
                  isCommentsCountShimmer
                      ? customShimmer(
                        childWidget: Row(
                          spacing: info.screenWidth * 0.01,
                          children: [
                            Container(
                              width: info.screenWidth * 0.05,
                              height: info.screenHeight * 0.015,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  info.screenWidth * 0.025,
                                ),
                              ),
                            ),
                            Container(
                              width: info.screenWidth * 0.1,
                              height: info.screenHeight * 0.02,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  info.screenWidth * 0.025,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      : Text(
                        // '${postDetailsCubit.commentsCount} comments',
                        commentsCountText.toString(),
                        style: TextStyles.inter18RegularWithOpacity.copyWith(
                          fontSize: info.screenWidth * 0.04,
                          color: ColorsManager.greyColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  const Spacer(),
                  // postDetailsCubit.RateAverage == null
                  isRateAverageShimmer
                      ? customShimmer(
                        childWidget: Row(
                          spacing: info.screenWidth * 0.01,
                          children: [
                            Container(
                              width: info.screenWidth * 0.05,
                              height: info.screenHeight * 0.015,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  info.screenWidth * 0.025,
                                ),
                              ),
                            ),
                            Container(
                              width: info.screenWidth * 0.1,
                              height: info.screenHeight * 0.02,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  info.screenWidth * 0.025,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      : Text(
                        // '${postDetailsCubit.RateAverage} Rate ',
                        rateAverageText.toString(),
                        style: TextStyles.inter18RegularWithOpacity.copyWith(
                          fontSize: info.screenWidth * 0.04,
                          color: ColorsManager.greyColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                ],
              ),
              // postDetailsCubit.RateAverage == null
              showStars
                  ? isRateAverageShimmer
                      ? customShimmer(
                        childWidget: Container(
                          margin: EdgeInsetsDirectional.only(
                            bottom: info.screenHeight * 0.01,
                          ),
                          width: double.infinity,
                          height: info.screenHeight * 0.04,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: info.screenWidth * 0.01,
                            children: [
                              Container(
                                width: info.screenWidth * 0.09,
                                height: info.screenHeight * 0.04,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    info.screenWidth * 0.09,
                                  ),
                                ),
                              ),
                              Container(
                                width: info.screenWidth * 0.09,
                                height: info.screenHeight * 0.04,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    info.screenWidth * 0.09,
                                  ),
                                ),
                              ),
                              Container(
                                width: info.screenWidth * 0.09,
                                height: info.screenHeight * 0.04,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    info.screenWidth * 0.09,
                                  ),
                                ),
                              ),
                              Container(
                                width: info.screenWidth * 0.09,
                                height: info.screenHeight * 0.04,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    info.screenWidth * 0.09,
                                  ),
                                ),
                              ),
                              Container(
                                width: info.screenWidth * 0.09,
                                height: info.screenHeight * 0.04,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    info.screenWidth * 0.09,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : Container(
                        margin: EdgeInsetsDirectional.only(
                          bottom: info.screenHeight * 0.01,
                        ),
                        alignment: Alignment.center,
                        child: RatingStars(
                          // value: postDetailsCubit.SelectedRatingValue ?? 0.0,
                          value: SelectedRatingValue ?? 0.0,
                          onValueChanged:
                              disableStars
                                  ? null
                                  : (value) => setRateAverage!(value.toInt()),
                          starBuilder:
                              (index, color) => Icon(
                                Icons.star,
                                color: color,
                                size: info.screenWidth * 0.075,
                              ),
                          starCount: 5,
                          starSize: info.screenWidth * 0.075,
                          valueLabelVisibility: false,
                        ),
                      )
                  : SizedBox(height: info.screenHeight * 0.015),
            ],
          ),
        ],
      ),
    );
  }
}


// Container postDetailsPostCard(
//     ) {
//
// }

