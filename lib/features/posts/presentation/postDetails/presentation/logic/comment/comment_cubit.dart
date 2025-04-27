import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../../../core/error/errorResponseModel.dart';
import '../../../../../data/model/entities/commentEntity.dart';
import '../../../../../domain/repository/postDetails/postDetails_repository.dart';
import '../post_details_cubit.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  PostDetailsRepository postDetailsRepository;
  CommentEntity comment;
  CommentCubit({required this.postDetailsRepository, required this.comment})
    : super(CommentInitial());

  ReactionType? selectedReactionType;

  Future<void> giveReaction({
    required BuildContext context,
    required int postId,
    required ReactionType reactionType,
  }) async {
    try {
      emit(GiveReactionLoading());
      final response = await postDetailsRepository.GiveReaction(
        postId,
        comment.id,
        reactionType,
      );
      if (response['statusCode'] == 204) {
        if (comment.currentUserReaction != reactionType) {
          if (reactionType == ReactionType.LIKE) {
            comment.numOfLikes++;
          } else if (reactionType == ReactionType.DIS_LIKE) {
            comment.numOfDisLikes++;
          }
          if (comment.currentUserReaction == ReactionType.LIKE) {
            comment.numOfLikes--;
          } else if (comment.currentUserReaction == ReactionType.DIS_LIKE) {
            comment.numOfDisLikes--;
          }
          comment.currentUserReaction = reactionType;
        } else {
          if (reactionType == ReactionType.LIKE) {
            comment.numOfLikes--;
          } else if (reactionType == ReactionType.DIS_LIKE) {
            comment.numOfDisLikes--;
          }
          comment.currentUserReaction = null;
        }

        if (context.mounted) {
          int commentIndex = context
              .read<PostDetailsCubit>()
              .comments!
              .indexWhere((comment) => comment.id == this.comment.id);
          context.read<PostDetailsCubit>().comments![commentIndex].numOfLikes =
              comment.numOfLikes;
          context
              .read<PostDetailsCubit>()
              .comments![commentIndex]
              .numOfDisLikes = comment.numOfDisLikes;
        }

        emit(GiveReactionSuccess());
      } else {
        comment.currentUserReaction = null;
        emit(GiveReactionFail('Failed to React to The post'));
      }
    } catch (e) {
      if (e is ErrorResponseModel) {
        if (e.message.toString().contains('already reacted')) {
          comment.currentUserReaction = reactionType;
          emit(GiveReactionFail('Already Reacted to this comment'));

          return;
        } else {
          emit(GiveReactionFail(e.message.toString()));
        }
      } else {
        emit(GiveReactionFail(e.toString()));
      }
      comment.currentUserReaction = null;
    }
  }
}
