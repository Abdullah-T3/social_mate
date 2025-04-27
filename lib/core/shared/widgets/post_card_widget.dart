import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/helper/extantions.dart';
import 'package:social_mate/core/shared/widgets/show_report_post_dialog_widget.dart';

import '../../../features/posts/presentation/postDetails/presentation/logic/post_details_cubit.dart';
import '../../Responsive/Models/device_info.dart';
import '../../di/di.dart';
import '../entities/post_entity.dart';
import '../../routing/routs.dart';
import '../model/create_report_model.dart';
import 'show_delete_dialog_widget.dart';
import 'animation/slide_Transition__widget.dart';
import '../../theming/colors.dart';
import '../../theming/styles.dart';
import '../../../features/posts/presentation/homePage/logic/cubit/home_cubit_cubit.dart';

class PostCardWidget extends StatefulWidget {
  final DeviceInfo deviceInfo;
  final PostEntity post;
  final bool idNotMatch;
  final void Function() onPressedDelete;
  const PostCardWidget({
    super.key,
    required this.deviceInfo,
    required this.idNotMatch,
    required this.post,
    required this.onPressedDelete,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PostCardWidgetState createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SlideTransitionWidget(
      child: InkWell(
        onTap: () {
          print(widget.post.id);
          PostDetailsCubit.setSelectedPost(widget.post.id);
          context.pushNamed(Routes.postDetailsScreen);
        },
        child: Container(
          width: widget.deviceInfo.screenWidth * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: widget.deviceInfo.screenWidth * 0.01,
                blurRadius: widget.deviceInfo.screenWidth * 0.02,
                offset: const Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.circular(
              widget.deviceInfo.screenWidth * 0.03,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.deviceInfo.screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.post.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyles.inter18BoldBlack.copyWith(
                          fontSize: widget.deviceInfo.screenWidth * 0.044,
                        ),
                      ),
                    ),
                    widget.idNotMatch
                        ? const SizedBox.shrink()
                        : IconButton(
                          onPressed: () {
                            final postId = widget.post.id;
                            if (postId == 0) {
                              return;
                            }
                            showDialog(
                              context: context,
                              builder:
                                  (context) => ShowDeleteDialogWidget(
                                    onPressed: widget.onPressedDelete,
                                    deviceInfo: widget.deviceInfo,
                                  ),
                            );

                            getIt.get<HomeCubit>().onRefresh();
                          },
                          icon: Icon(
                            Icons.close,
                            color: ColorsManager.redColor.withOpacity(0.7),
                            size: widget.deviceInfo.screenWidth * 0.08,
                          ),
                        ),
                  ],
                ),
                Divider(
                  color: Colors.black,
                  thickness: widget.deviceInfo.screenWidth * 0.002,
                  height: widget.deviceInfo.screenHeight * 0.015,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.post.createdBy.fullName,
                        style: TextStyles.inter14BoldBlue.copyWith(
                          fontSize: widget.deviceInfo.screenWidth * 0.04,
                          color: ColorsManager.primaryColorBold.withOpacity(
                            0.8,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      widget.post.FormattedDate,
                      style: TextStyles.inter14BoldBlue.copyWith(
                        fontSize: widget.deviceInfo.screenWidth * 0.03,
                        color: ColorsManager.primaryColorBold.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: widget.deviceInfo.localHeight * 0.01),
                Text(
                  widget.post.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style: TextStyles.inter18RegularWithOpacity.copyWith(
                    fontSize: widget.deviceInfo.screenWidth * 0.04,
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: IconButton(
                    onPressed: () async {
                      // Handle report action
                      showDialog(
                        context: context,
                        builder:
                            (context) => BlocProvider(
                              create:
                                  (context) =>
                                      getIt<HomeCubit>()..reportCategories(),
                              child: ShowReportPostDialogWidget(
                                deviceInfo: widget.deviceInfo,
                                onPressedReport: (categoryId, reason) async {
                                  await getIt.get<HomeCubit>().reportPost(
                                    widget.post.id,
                                    CreateReportModel(
                                      categoryId: categoryId,
                                      reason: reason,
                                    ),
                                  );
                                  // ignore: use_build_context_synchronously
                                  context.pop();
                                },
                              ),
                            ),
                      );
                    },
                    icon: Icon(
                      Icons.flag,
                      color: ColorsManager.redColor,
                      size: widget.deviceInfo.screenWidth * 0.06,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
