import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/helper/extantions.dart';
import 'package:social_mate/features/filtering/presentation/cubit/filtered_users/filtered_users_cubit.dart';
import 'package:social_mate/features/filtering/presentation/widgets/filtering_tile.dart';
import 'package:social_mate/features/posts/presentation/homePage/logic/cubit/home_cubit_cubit.dart';

import '../../../../core/Responsive/ui_component/info_widget.dart';
import '../../../../core/di/di.dart';
import '../../../../core/shared/entities/post_entity.dart';
import '../../../../core/shared/widgets/animation/tween_animation_widget.dart'
    show TweenAnimationWidget;
import '../../../../core/shared/widgets/header_widget.dart' show HeaderWidget;
import '../../../../core/shared/widgets/post_card_widget.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/userMainDetails/userMainDetails_cubit.dart'
    show userMainDetailsCubit;
import '../cubit/filtering_cubit.dart';
import '../cubit/sharing_data/sharing_data_cubit.dart';

//import 'package:social_media/features/filtering/domain/entities/filtering_post_entity.dart';

//import 'package:social_media/features/filtering/presentation/widgets/filtered_post_card.dart';

//import 'package:social_media/features/posts/presentation/homePage/logic/cubit/home_cubit_cubit.dart';

class FilteringScreen extends StatefulWidget {
  const FilteringScreen({super.key});

  @override
  State<FilteringScreen> createState() => _FilteringScreenState();
}

class _FilteringScreenState extends State<FilteringScreen> {
  Map<String, dynamic> queryParameters = {};
  List<PostEntity> posts = [];
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }
  // void _showSnackBar(bool isConnected) {
  //   if (isConnected) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Connection is back'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('No internet connection'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  void _onScroll() {
    final token = context.read<userMainDetailsCubit>().state.token;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      final queryParams = context.read<SharingDataCubit>().state.queryParams;
      context.read<FilteringCubit>().loadMoreFilteredPosts(
        queryParameters: queryParams,
        token: token!,
      );
    }
    //print('queryParameters after pagination : $queryParameters');
  }

  @override
  Widget build(BuildContext context) {
    return InfoWidget(
      builder: (context, deviceInfo) {
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.vertical,
              clipBehavior: Clip.antiAlias,
              child: BlocListener<SharingDataCubit, SharingDataState>(
                listener: (context, sharingState) {
                  if (sharingState.posts.isEmpty) {
                    posts.clear();
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HeaderWidget(
                      isAdmin: false,
                      isUser: false,
                      isBackButtonVisible: true,
                      info: deviceInfo,
                      onBackPressed: context.pop,
                      titleImageAsset: 'assets/images/Title_img.png',
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: deviceInfo.screenWidth * 0.04,
                        vertical: deviceInfo.screenHeight * 0.01,
                      ),
                      child: FilteringTile(
                        homeCubit: context.read<HomeCubit>(),
                        filteringCubit: context.read<FilteringCubit>(),
                        sharingDataCubit: context.read<SharingDataCubit>(),
                        filteredUsersCubit: context.read<FilteredUsersCubit>(),
                      ),
                    ),
                    SizedBox(height: deviceInfo.screenHeight * 0.02),
                    BlocBuilder<FilteringCubit, FilteringState>(
                      builder: (context, state) {
                        if (state is FilteredPostsIsLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: ColorsManager.primaryColor,
                            ),
                          );
                        } else if (state is FilteredPostsIsLoaded) {
                          // if (state.filteredPosts.isNotEmpty) {
                          //   final newPosts = state.filteredPosts.where((newPost) {
                          //     return !posts.any((existingPost) =>
                          //         existingPost.id == newPost.id);
                          //   }).toList();
                          //   posts.addAll(newPosts);
                          // }
                          posts = state.filteredPosts;
                          if (posts.isEmpty) {}

                          return Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    posts.length + (state.hasMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == posts.length && state.hasMore) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  final isNotMatch =
                                      posts[index].createdBy.id ==
                                              getIt<userMainDetailsCubit>()
                                                  .state
                                                  .userId
                                          ? false
                                          : true;
                                  return TweenAnimationWidget(
                                    deviceInfo: deviceInfo,
                                    index: index,
                                    child: PostCardWidget(
                                      onPressedDelete: () {
                                        getIt.get<HomeCubit>().deletePost(
                                          posts[index].id,
                                        );

                                        setState(() {
                                          posts.removeWhere(
                                            (post) =>
                                                post.id == posts[index].id,
                                          );
                                        });
                                        // final query = context
                                        //     .read<SharingDataCubit>()
                                        //     .state
                                        //     .queryParams;
                                        // final token = context
                                        //     .read<userMainDetailsCubit>()
                                        //     .state
                                        //     .token!;
                                        // context
                                        //     .read<FilteringCubit>()
                                        //     .getFilteredPosts(
                                        //         token: token,
                                        //         queryParameters: query);
                                        context.pop();
                                      },
                                      deviceInfo: deviceInfo,
                                      idNotMatch: isNotMatch,
                                      post: posts[index],
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        } else if (state is FilteredPostsHasError) {
                          return Text(
                            'Sorry something went wrong , Try again',
                            style: TextStyle(color: Colors.red),
                          );
                        } else if (state is FilteredPostsNetworkError) {
                          return Center(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: deviceInfo.screenHeight * 0.02,
                                  ),
                                  child: Image.asset(
                                    'assets/images/no-internet.png',
                                    height: 100,
                                  ),
                                ),
                                Text(
                                  'No Internet Connection',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          );
                        } else if (state is FilteredPostsIsEmpty) {
                          return Center(child: Text('No posts found'));
                        } else {
                          return Center(
                            child: Text('No posts yet , try to filter some'),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
