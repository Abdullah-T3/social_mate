import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/helper/extantions.dart';

import '../../../../../../core/Responsive/Models/device_info.dart';
import '../../../../../../core/Responsive/ui_component/info_widget.dart';
import '../../../../../../core/di/di.dart';
import '../../../../../../core/routing/routs.dart';
import '../../../../../../core/shared/model/create_report_model.dart';
import '../../../../../../core/shared/widgets/CommentCard.dart';
import '../../../../../../core/shared/widgets/Shimmer/ShimmerStyle.dart';
import '../../../../../../core/shared/widgets/animation/slide_Transition__widget.dart';
import '../../../../../../core/shared/widgets/animation/tween_animation_widget.dart';
import '../../../../../../core/shared/widgets/cherryToast/CherryToastMsgs.dart';
import '../../../../../../core/shared/widgets/postDetailsPostCard.dart';
import '../../../../../../core/shared/widgets/show_delete_dialog_widget.dart';
import '../../../../../../core/shared/widgets/show_report_post_dialog_widget.dart';
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/styles.dart';
import '../../../../../../core/userMainDetails/userMainDetails_cubit.dart';
import '../../../homePage/logic/cubit/home_cubit_cubit.dart';
import '../logic/comment/comment_cubit.dart';
import '../logic/post_details_cubit.dart';

class post_details_screen extends StatefulWidget {
  @override
  State createState() => _post_details_screenState();
}

class _post_details_screenState extends State<post_details_screen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    context.read<PostDetailsCubit>().getPostDetails();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        context.read<PostDetailsCubit>().hasMoreComments) {
      context.read<PostDetailsCubit>().getPostComments();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InfoWidget(
      builder: (context, info) {
        return SafeArea(
          child: BlocConsumer<PostDetailsCubit, PostDetailsState>(
            listener: (context, state) {
              if (state is PostDetailsLoaded) {
                Future.wait([
                  context.read<PostDetailsCubit>().getPostCommentsCount(),
                  context.read<PostDetailsCubit>().getPostRateAverage(),
                  context.read<PostDetailsCubit>().getPostComments(),
                ]);
              }
              if (state is SuccessPostRate) {
                context.read<PostDetailsCubit>().getPostRateAverage();
                CherryToastMsgs.CherryToastSuccess(
                  info: info,
                  context: context,
                  title: 'Success!!',
                  description: 'You Rated The Post Successfully',
                );
              }

              if (state is FailPostRate) {
                CherryToastMsgs.CherryToastError(
                  info: info,
                  context: context,
                  title: 'Failed!!',
                  description: 'You Rated The Post Failed',
                );
              }

              // if (state is GiveReactionSuccess) {
              //   CherryToastMsgs.CherryToastSuccess(
              //     info: info,
              //     context: context,
              //     title: 'Success!!',
              //     description: 'You Reacted To The Comment Successfully',
              //   );
              // }
              //
              // if (state is GiveReactionFail) {
              //   CherryToastMsgs.CherryToastError(
              //     info: info,
              //     context: context,
              //     title: 'Failed!!',
              //     description: 'You Reacted To The Comment Failed',
              //   );
              // }

              if (state is CommentsCreated) {
                context.read<PostDetailsCubit>().hasMoreComments = true;
                Future.wait([
                  context.read<PostDetailsCubit>().getPostCommentsCount(),
                  context.read<PostDetailsCubit>().getPostComments(
                    pageOffset: 0,
                    pageSize: 1,
                  ),
                ]);
                CherryToastMsgs.CherryToastSuccess(
                  info: info,
                  context: context,
                  title: 'Success!!',
                  description: 'Your Comment is Successfully sent',
                );
              }

              if (state is CommentsError) {
                CherryToastMsgs.CherryToastError(
                  info: info,
                  context: context,
                  title: 'Failed!!',
                  description: state.message,
                );
              }

              if (state is deleteCommentSuccess) {
                context.read<PostDetailsCubit>().comments!.removeWhere(
                  (comment) => comment.id == state.deletedCommentId,
                );
                Future.wait([
                  context.read<PostDetailsCubit>().getPostCommentsCount(),
                ]);

                if (context.read<PostDetailsCubit>().comments!.length !=
                    context.read<PostDetailsCubit>().commentsCount) {
                  context.read<PostDetailsCubit>().getPostComments();
                }

                CherryToastMsgs.CherryToastSuccess(
                  info: info,
                  context: context,
                  title: 'Success!!',
                  description: 'Your Comment is Successfully deleted',
                );

                Navigator.pop(context);
              }

              if (state is deleteCommentFail) {
                CherryToastMsgs.CherryToastError(
                  info: info,
                  context: context,
                  title: 'Failed!!',
                  description: state.message,
                );
              }
            },
            builder: (context, state) {
              final postDetailsCubit = context.read<PostDetailsCubit>();
              final userMainDetails = context.read<userMainDetailsCubit>();

              return Scaffold(
                body: RefreshIndicator(
                  onRefresh:
                      context.read<PostDetailsCubit>().refreshPostDetails,
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomScrollView(
                          controller: _scrollController,
                          slivers: [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsetsDirectional.only(
                                  top: info.screenHeight * 0.019,
                                ),
                                child: Column(
                                  children: [
                                    _buildHeader(info, context),
                                    Divider(
                                      height: info.localHeight * 0.01,
                                      thickness: info.screenWidth * 0.001,
                                      color: ColorsManager.greyColor,
                                    ),
                                    PostDetailsPostCard(
                                      info: info,
                                      titleText: postDetailsCubit.post?.title,
                                      isTitleShimmer:
                                          state is PostDetailsLoading ||
                                          state is PostDetailsInitial,
                                      showDeleteButton:
                                          userMainDetails.state.userId ==
                                          postDetailsCubit.post?.createdBy.id,
                                      DeleteButtonOnPressed: () {
                                        context
                                            .read<PostDetailsCubit>()
                                            .commentfocusNode
                                            .unfocus();
                                        showDialog(
                                          context: context,
                                          builder:
                                              (
                                                context1,
                                              ) => ShowDeleteDialogWidget(
                                                onPressed: () {
                                                  context1.pop();
                                                  getIt
                                                      .get<HomeCubit>()
                                                      .deletePost(
                                                        context
                                                            .read<
                                                              PostDetailsCubit
                                                            >()
                                                            .post!
                                                            .id,
                                                      );
                                                  context1.pushReplacementNamed(
                                                    Routes.homePage,
                                                  );
                                                },
                                                deviceInfo: info,
                                              ),
                                        );
                                      },
                                      isNameAndDateShimmer:
                                          state is PostDetailsLoading ||
                                          state is PostDetailsInitial,
                                      fullNameText:
                                          postDetailsCubit
                                              .post
                                              ?.createdBy
                                              .fullName,
                                      formattedDateText:
                                          postDetailsCubit.post?.FormattedDate,
                                      showReportButton: true,
                                      ReportButtonOnPressed: () {
                                        context
                                            .read<PostDetailsCubit>()
                                            .commentfocusNode
                                            .unfocus();
                                        showDialog(
                                          context: context,
                                          builder:
                                              (context1) => BlocProvider(
                                                create:
                                                    (context) =>
                                                        getIt<HomeCubit>()
                                                          ..reportCategories(),
                                                child: ShowReportPostDialogWidget(
                                                  deviceInfo: info,
                                                  onPressedReport: (
                                                    categoryId,
                                                    reason,
                                                  ) async {
                                                    await getIt
                                                        .get<HomeCubit>()
                                                        .reportPost(
                                                          postDetailsCubit
                                                              .post!
                                                              .id,
                                                          CreateReportModel(
                                                            categoryId:
                                                                categoryId,
                                                            reason: reason,
                                                          ),
                                                        );
                                                    // ignore: use_build_context_synchronously
                                                    context.pop();

                                                    CherryToastMsgs.CherryToastSuccess(
                                                      info: info,
                                                      // ignore: use_build_context_synchronously
                                                      context: context,
                                                      title: 'Success!!',
                                                      description:
                                                          'You Reported The Post Successfully',
                                                    );
                                                  },
                                                ),
                                              ),
                                        );
                                      },
                                      isContentShimmer:
                                          state is PostDetailsLoading ||
                                          state is PostDetailsInitial,
                                      contentText:
                                          postDetailsCubit.post?.content,
                                      isCommentsCountShimmer:
                                          postDetailsCubit.commentsCount ==
                                          null,
                                      commentsCountText:
                                          '${postDetailsCubit.commentsCount} comments',
                                      isRateAverageShimmer:
                                          postDetailsCubit.rateAverage == null,
                                      rateAverageText:
                                          '${postDetailsCubit.rateAverage} Rate',
                                      showStars: true,
                                      SelectedRatingValue:
                                          postDetailsCubit.selectedRatingValue,
                                      setRateAverage:
                                          (postDetailsCubit.setRateAverage),
                                    ),
                                    Container(
                                      margin: EdgeInsetsDirectional.only(
                                        top: info.screenHeight * 0.02,
                                        start: info.screenWidth * 0.02,
                                      ),
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Text(
                                        'Comments',
                                        style: TextStyles.inter18BoldBlack
                                            .copyWith(
                                              fontSize: info.screenWidth * 0.05,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            postDetailsCubit.comments == null ||
                                    postDetailsCubit.comments == []
                                ? SliverToBoxAdapter(
                                  child: customShimmer(
                                    childWidget: Column(
                                      children: [
                                        Container(
                                          width: info.screenWidth * 0.9,
                                          height: info.screenHeight * 0.13,
                                          margin: EdgeInsetsDirectional.only(
                                            top: info.screenHeight * 0.02,
                                          ),
                                          padding: EdgeInsetsDirectional.only(
                                            start: info.screenWidth * 0.05,
                                            end: info.screenWidth * 0.05,
                                            top: info.screenHeight * 0.01,
                                            bottom: info.screenHeight * 0.01,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(
                                                info.screenWidth * 0.07,
                                              ),
                                              bottomLeft: Radius.circular(
                                                info.screenWidth * 0.07,
                                              ),
                                              bottomRight: Radius.circular(
                                                info.screenWidth * 0.07,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: info.screenHeight * 0.01,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsetsDirectional.only(
                                                    start:
                                                        info.screenWidth * 0.04,
                                                  ),
                                              width: info.screenWidth * 0.05,
                                              height: info.screenHeight * 0.015,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      info.screenWidth * 0.025,
                                                    ),
                                              ),
                                            ),
                                            Container(
                                              width: info.screenWidth * 0.08,
                                              height: info.screenHeight * 0.035,
                                              margin:
                                                  EdgeInsetsDirectional.only(
                                                    start:
                                                        info.screenWidth * 0.02,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      info.screenWidth * 0.09,
                                                    ),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsetsDirectional.only(
                                                    start:
                                                        info.screenWidth * 0.02,
                                                  ),
                                              width: info.screenWidth * 0.05,
                                              height: info.screenHeight * 0.015,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      info.screenWidth * 0.025,
                                                    ),
                                              ),
                                            ),
                                            Container(
                                              width: info.screenWidth * 0.08,
                                              height: info.screenHeight * 0.035,
                                              margin:
                                                  EdgeInsetsDirectional.only(
                                                    start:
                                                        info.screenWidth * 0.02,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      info.screenWidth * 0.09,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: info.screenWidth * 0.9,
                                          height: info.screenHeight * 0.13,
                                          margin: EdgeInsetsDirectional.only(
                                            top: info.screenHeight * 0.02,
                                          ),
                                          padding: EdgeInsetsDirectional.only(
                                            start: info.screenWidth * 0.05,
                                            end: info.screenWidth * 0.05,
                                            top: info.screenHeight * 0.01,
                                            bottom: info.screenHeight * 0.01,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(
                                                info.screenWidth * 0.07,
                                              ),
                                              bottomLeft: Radius.circular(
                                                info.screenWidth * 0.07,
                                              ),
                                              bottomRight: Radius.circular(
                                                info.screenWidth * 0.07,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: info.screenHeight * 0.01,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsetsDirectional.only(
                                                    start:
                                                        info.screenWidth * 0.04,
                                                  ),
                                              width: info.screenWidth * 0.05,
                                              height: info.screenHeight * 0.015,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      info.screenWidth * 0.025,
                                                    ),
                                              ),
                                            ),
                                            Container(
                                              width: info.screenWidth * 0.08,
                                              height: info.screenHeight * 0.035,
                                              margin:
                                                  EdgeInsetsDirectional.only(
                                                    start:
                                                        info.screenWidth * 0.02,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      info.screenWidth * 0.09,
                                                    ),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsetsDirectional.only(
                                                    start:
                                                        info.screenWidth * 0.02,
                                                  ),
                                              width: info.screenWidth * 0.05,
                                              height: info.screenHeight * 0.015,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      info.screenWidth * 0.025,
                                                    ),
                                              ),
                                            ),
                                            Container(
                                              width: info.screenWidth * 0.08,
                                              height: info.screenHeight * 0.035,
                                              margin:
                                                  EdgeInsetsDirectional.only(
                                                    start:
                                                        info.screenWidth * 0.02,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      info.screenWidth * 0.09,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: info.screenWidth * 0.9,
                                          height: info.screenHeight * 0.13,
                                          margin: EdgeInsetsDirectional.only(
                                            top: info.screenHeight * 0.02,
                                          ),
                                          padding: EdgeInsetsDirectional.only(
                                            start: info.screenWidth * 0.05,
                                            end: info.screenWidth * 0.05,
                                            top: info.screenHeight * 0.01,
                                            bottom: info.screenHeight * 0.01,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(
                                                info.screenWidth * 0.07,
                                              ),
                                              bottomLeft: Radius.circular(
                                                info.screenWidth * 0.07,
                                              ),
                                              bottomRight: Radius.circular(
                                                info.screenWidth * 0.07,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: info.screenHeight * 0.01,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsetsDirectional.only(
                                                    start:
                                                        info.screenWidth * 0.04,
                                                  ),
                                              width: info.screenWidth * 0.05,
                                              height: info.screenHeight * 0.015,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      info.screenWidth * 0.025,
                                                    ),
                                              ),
                                            ),
                                            Container(
                                              width: info.screenWidth * 0.08,
                                              height: info.screenHeight * 0.035,
                                              margin:
                                                  EdgeInsetsDirectional.only(
                                                    start:
                                                        info.screenWidth * 0.02,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      info.screenWidth * 0.09,
                                                    ),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsetsDirectional.only(
                                                    start:
                                                        info.screenWidth * 0.02,
                                                  ),
                                              width: info.screenWidth * 0.05,
                                              height: info.screenHeight * 0.015,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      info.screenWidth * 0.025,
                                                    ),
                                              ),
                                            ),
                                            Container(
                                              width: info.screenWidth * 0.08,
                                              height: info.screenHeight * 0.035,
                                              margin:
                                                  EdgeInsetsDirectional.only(
                                                    start:
                                                        info.screenWidth * 0.02,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      info.screenWidth * 0.09,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                : SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    childCount:
                                        postDetailsCubit.comments!.length == 0
                                            ? 1
                                            : postDetailsCubit.comments!.length,
                                    (context, index) =>
                                        postDetailsCubit.comments!.length > 0
                                            ? TweenAnimationWidget(
                                              index: index,
                                              deviceInfo: info,
                                              child: SlideTransitionWidget(
                                                child: BlocProvider(
                                                  key: ValueKey(
                                                    postDetailsCubit
                                                        .comments![index]
                                                        .id,
                                                  ),
                                                  create:
                                                      (_) => CommentCubit(
                                                        postDetailsRepository:
                                                            getIt(),
                                                        comment:
                                                            postDetailsCubit
                                                                .comments![index],
                                                      ),
                                                  child: BlocConsumer<
                                                    CommentCubit,
                                                    CommentState
                                                  >(
                                                    listener: (context, state) {
                                                      if (state
                                                          is GiveReactionSuccess) {
                                                        CherryToastMsgs.CherryToastSuccess(
                                                          info: info,
                                                          context: context,
                                                          title: 'Success!!',
                                                          description:
                                                              'You Reacted To The Comment Successfully',
                                                        );
                                                      }

                                                      if (state
                                                          is GiveReactionFail) {
                                                        CherryToastMsgs.CherryToastError(
                                                          info: info,
                                                          context: context,
                                                          title: 'Failed!!',
                                                          description:
                                                              state.message,
                                                        );
                                                      }
                                                    },
                                                    builder:
                                                        (
                                                          context,
                                                          state,
                                                        ) => CommentCard(
                                                          key: ValueKey(
                                                            postDetailsCubit
                                                                .comments![index]
                                                                .id,
                                                          ),
                                                          index: index,
                                                          comment:
                                                              postDetailsCubit
                                                                  .comments![index],
                                                          info: info,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            )
                                            : Container(
                                              margin:
                                                  EdgeInsetsDirectional.only(
                                                    top:
                                                        info.screenHeight *
                                                        0.07,
                                                  ),
                                              width: info.screenWidth * 0.6,
                                              height: info.screenHeight * 0.3,
                                              child: Image.asset(
                                                'assets/images/noComments.png',
                                              ),
                                            ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                      Container(
                        height: info.screenHeight * 0.076,
                        // color: Colors.red,
                        padding: EdgeInsetsDirectional.only(
                          bottom: info.screenHeight * 0.007,
                          top: info.screenHeight * 0.007,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: info.screenWidth * 0.85,
                              padding: EdgeInsetsDirectional.only(
                                start: info.screenWidth * 0.04,
                                end: info.screenWidth * 0.01,
                              ),
                              child: TextField(
                                controller:
                                    postDetailsCubit.createCommentController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: ColorsManager.lightGreyColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      info.screenWidth * 0.05,
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: 'Add comment',
                                ),
                                textInputAction: TextInputAction.send,
                                focusNode:
                                    context
                                        .read<PostDetailsCubit>()
                                        .commentfocusNode,
                                onSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(
                                    context
                                        .read<PostDetailsCubit>()
                                        .commentfocusNode,
                                  );
                                  postDetailsCubit.createComment(context);
                                },
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                postDetailsCubit.createComment(context);
                              },
                              icon: Icon(
                                Icons.send,
                                color: ColorsManager.primaryColor,
                                size: info.screenWidth * 0.08,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHeader(DeviceInfo deviceInfo, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: deviceInfo.localWidth * 0.02,
        vertical: deviceInfo.localHeight * 0.01,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: deviceInfo.screenWidth * 0.02,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: deviceInfo.screenWidth * 0.08,
              color: ColorsManager.primaryColor,
            ),
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.all(deviceInfo.screenWidth * 0.01),
              backgroundColor: ColorsManager.lightGreyColor,
              shadowColor: Colors.transparent,
            ),
          ),
          InkWell(
            child: Image.asset(
              'assets/images/Title_img.png',
              width: deviceInfo.localWidth * 0.48,
              height: deviceInfo.localHeight * 0.06,
              fit: BoxFit.contain,
            ),
            onTap: () {
              context.read<PostDetailsCubit>().getPostComments();
            },
          ),
        ],
      ),
    );
  }
}
