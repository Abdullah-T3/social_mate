import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/shared/widgets/show_delete_dialog_widget.dart';

import '../../../features/posts/data/model/entities/commentEntity.dart';
import '../../../features/posts/presentation/postDetails/presentation/logic/comment/comment_cubit.dart';
import '../../../features/posts/presentation/postDetails/presentation/logic/post_details_cubit.dart';
import '../../Responsive/Models/device_info.dart';
import '../../theming/colors.dart';
import '../../theming/styles.dart';
import '../../userMainDetails/userMainDetails_cubit.dart';

class CommentCard extends StatelessWidget {
  final DeviceInfo info;
  final int index;
  final CommentEntity comment;
  const CommentCard({
    required this.info,
    required this.index,
    required this.comment,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: info.screenWidth * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: info.screenHeight * 0.13),
              margin: EdgeInsetsDirectional.only(top: info.screenHeight * 0.02),
              padding: EdgeInsetsDirectional.only(
                start: info.screenWidth * 0.05,
                end: info.screenWidth * 0.05,
                top: info.screenHeight * 0.01,
                bottom: info.screenHeight * 0.01,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(info.screenWidth * 0.07),
                  bottomLeft: Radius.circular(info.screenWidth * 0.07),
                  bottomRight: Radius.circular(info.screenWidth * 0.07),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorsManager.blackColor.withOpacity(0.35),
                    blurRadius: info.screenWidth * 0.05,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment.createdBy.fullName,
                            style: TextStyles.inter18BoldBlack.copyWith(
                              fontSize: info.screenWidth * 0.035,
                              color: ColorsManager.blackColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            comment.FormattedDate,
                            style: TextStyles.inter18Regularblack.copyWith(
                              fontSize: info.screenWidth * 0.035,
                              color: ColorsManager.greyColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      if (comment.createdBy.id ==
                          context.read<userMainDetailsCubit>().state.userId)
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context1) => ShowDeleteDialogWidget(
                                    deviceInfo: info,
                                    onPressed: () {
                                      context
                                          .read<PostDetailsCubit>()
                                          .deleteComment(comment.id);
                                    },
                                  ),
                            );
                          },
                          icon: Icon(
                            Icons.close,
                            color: ColorsManager.redColor.withOpacity(0.7),
                            size: info.screenWidth * 0.07,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: info.localHeight * 0.01),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsetsDirectional.only(
                      start: info.screenWidth * 0.03,
                      bottom: info.screenHeight * 0.013,
                    ),
                    child: Text(
                      comment.content,
                      textAlign: TextAlign.start,
                      softWrap: true,
                      style: TextStyles.inter18RegularWithOpacity.copyWith(
                        fontSize: info.screenWidth * 0.04,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsetsDirectional.only(
                start: info.screenWidth * 0.03,
              ),
              child: Row(
                children: [
                  Text(
                    comment.numOfLikes.toString(),
                    style: TextStyles.inter18RegularWithOpacity.copyWith(
                      fontSize: info.screenWidth * 0.04,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // context.read<PostDetailsCubit>().giveReaction(commentId: comment.id,index: index, reactionType: ReactionType.LIKE);
                      context.read<CommentCubit>().giveReaction(
                        context: context,
                        postId: context.read<PostDetailsCubit>().post!.id,
                        reactionType: ReactionType.LIKE,
                      );
                    },
                    icon: Icon(
                      comment.currentUserReaction == ReactionType.LIKE
                          ? Icons.thumb_up_alt_rounded
                          : Icons.thumb_up_alt_outlined,
                      color: ColorsManager.primaryColor,
                      size: info.screenWidth * 0.06,
                    ),
                  ),
                  Text(
                    comment.numOfDisLikes.toString(),
                    style: TextStyles.inter18RegularWithOpacity.copyWith(
                      fontSize: info.screenWidth * 0.04,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // context.read<PostDetailsCubit>().giveReaction(commentId: comment.id,index: index, reactionType: ReactionType.DIS_LIKE);
                      context.read<CommentCubit>().giveReaction(
                        context: context,
                        postId: context.read<PostDetailsCubit>().post!.id,
                        reactionType: ReactionType.DIS_LIKE,
                      );
                    },
                    icon: Icon(
                      comment.currentUserReaction == ReactionType.DIS_LIKE
                          ? Icons.thumb_down_alt_rounded
                          : Icons.thumb_down_alt_outlined,
                      color: ColorsManager.redColor,
                      size: info.screenWidth * 0.06,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
