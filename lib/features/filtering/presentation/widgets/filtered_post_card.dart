import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/features/filtering/presentation/cubit/filtering_cubit.dart';
import 'package:social_mate/features/filtering/presentation/widgets/report_dialog_marwan.dart';
import 'package:social_mate/features/posts/presentation/homePage/logic/cubit/home_cubit_cubit.dart';

import '../../../../core/Responsive/ui_component/info_widget.dart';
import '../../../../core/di/di.dart' show getIt;
import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart' show TextStyles;
import '../../../../core/userMainDetails/jwt_token_decode/data/model/jwtModel.dart';
import '../../../../core/userMainDetails/jwt_token_decode/data/repository/jwt_token_decode_repository_imp.dart';
import '../../../../core/userMainDetails/userMainDetails_cubit.dart';

//import 'package:social_media/core/routing/routs.dart';
//import 'package:social_media/core/shared/show_delete_dialog_widget.dart';

//import 'package:social_media/features/posts/presentation/postDetails/presentation/logic/post_details_cubit.dart';

class FilteredPostCard extends StatefulWidget {
  final FilteringCubit filteringCubit;
  final HomeCubit homeCubit;
  final int postId;
  final int postOwnerId;
  final String title;
  final String postOwner;
  final String date;
  final String content;
  final Function(int)? onPostDeleted;

  const FilteredPostCard({
    super.key,
    required this.title,
    required this.postOwner,
    required this.date,
    required this.content,
    required this.postOwnerId,
    required this.postId,
    this.onPostDeleted,
    required this.homeCubit,
    required this.filteringCubit,
  });

  @override
  State<FilteredPostCard> createState() => _FilteredPostCardState();
}

class _FilteredPostCardState extends State<FilteredPostCard> {
  final JwtTokenDecodeRepositoryImp decodedToken =
      getIt.get<JwtTokenDecodeRepositoryImp>();
  late final JwtModel decodedTokenFromChache;

  @override
  void initState() {
    super.initState();
  }

  // void _deletePost(BuildContext context, int postId, String token,
  //     Map<String, dynamic> params) {
  //   widget.homeCubit.deletePost(postId).then((_) {
  //     if (widget.onPostDeleted != null) {
  //       widget.onPostDeleted!(postId);
  //     }
  //     widget.filteringCubit
  //         .getFilteredPosts(token: token, queryParameters: params);
  //   }).catchError((error) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to delete post")),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return InfoWidget(
      builder: (context, deviceInfo) {
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: ColorsManager.primaryColor, width: 1),
            borderRadius: BorderRadius.circular(deviceInfo.screenWidth * 0.03),
          ),
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.all(deviceInfo.screenWidth * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Text(
                        widget.title,
                        style: TextStyles.inter18BoldBlack,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      //TODO: icon only shown if postOwnerId = currentUserId , need to pass currentUserId
                      child: Visibility(
                        visible:
                            (context
                                    .read<userMainDetailsCubit>()
                                    .state
                                    .userId ==
                                widget.postOwnerId),
                        child: IconButton(
                          onPressed: () {
                            // deleteDialog(
                            //   context,
                            //   widget.postId,
                            //   deviceInfo,
                            // );
                            // showDialog(
                            //     context: context,
                            //     builder: (context) => ShowDeleteDialogWidget(
                            //         onPressed: () {
                            //           _deletePost(context, widget.postId,
                            //               token!, query);
                            //           FocusScope.of(context).unfocus();
                            //           context.pop();
                            //         },
                            //         deviceInfo: deviceInfo));
                          },
                          icon: Icon(
                            Icons.delete_forever,
                            color: ColorsManager.redColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Divider(color: Colors.black),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.postOwner,
                      style: TextStyle(
                        fontSize: deviceInfo.screenWidth * 0.04,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          widget.date,
                          style: TextStyle(
                            fontSize: deviceInfo.screenWidth * 0.035,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(width: deviceInfo.screenWidth * 0.02),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: deviceInfo.screenHeight * 0.01),

                Text(
                  widget.content,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 7, 7, 7),
                  ),
                ),

                const SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // PostDetailsCubit().(widget.postId);
                        // context.pushNamed(
                        //   Routes.postDetailsScreen,
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            deviceInfo.screenWidth * 0.04,
                          ),
                        ),
                      ),
                      child: const Text("Show more"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) =>
                                  ReportDialogMarwan(deviceInfo: deviceInfo),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            deviceInfo.screenWidth * 0.04,
                          ),
                        ),
                      ),
                      child: const Text("Report"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
