import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/helper/extantions.dart';

import '../../../../../core/Responsive/Models/device_info.dart';
import '../../../../../core/Responsive/ui_component/info_widget.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/routing/routs.dart';
import '../../../../../core/shared/widgets/Shimmer/ShimmerStyle.dart';
import '../../../../../core/shared/widgets/animation/slide_Transition__widget.dart';
import '../../../../../core/shared/widgets/animation/tween_animation_widget.dart';
import '../../../../../core/shared/widgets/cherryToast/CherryToastMsgs.dart';
import '../../../../../core/shared/widgets/custom_drawer_widget.dart';
import '../../../../../core/shared/widgets/header_widget.dart';
import '../../../../../core/shared/widgets/log_out_dialog.dart';
import '../../../../../core/shared/widgets/show_create_post_dialog_widget.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/userMainDetails/userMainDetails_cubit.dart';
import '../logic/cubit/home_cubit_cubit.dart';
import 'widgets/create_post_widget.dart';
import '../../../../../core/shared/widgets/post_card_widget.dart';

class HomepageView extends StatefulWidget {
  const HomepageView({super.key});

  @override
  State<HomepageView> createState() => _HomepageViewState();
}

class _HomepageViewState extends State<HomepageView>
    with TickerProviderStateMixin {
  late final AnimationController _createPostAnimationController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _createPostAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _scrollController = ScrollController()..addListener(_onScroll);
    // Fetch posts initially
    context.read<HomeCubit>().getPosts();
  }

  @override
  void dispose() {
    _createPostAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final homeCubit = context.read<HomeCubit>();
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !homeCubit.isLoadingMore &&
        homeCubit.hasMorePosts) {
      homeCubit.loadMorePosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return InfoWidget(
      builder: (context, deviceInfo) {
        return SafeArea(
          child: Scaffold(
            endDrawer: CustomDrawerWidget(inMemberView: true),
            body: BlocListener<HomeCubit, HomeState>(
              listener: (context, state) {
                if (state is PostDeleted || state is PostCreated) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.pop();
                    context.read<HomeCubit>().onRefresh();
                  });
                } else if (state is PostError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    CherryToastMsgs.CherryToastError(
                      info: deviceInfo,
                      context: context,
                      title: "Error",
                      description: state.message,
                    );
                  });
                }
              },
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return RefreshIndicator(
                    color: ColorsManager.primaryColor,
                    backgroundColor: Colors.white,
                    onRefresh: () => context.read<HomeCubit>().onRefresh(),
                    child: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          _buildHeaderSection(deviceInfo),
                          _buildPostList(deviceInfo, state),
                          _buildLoadingIndicator(deviceInfo, state),
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: deviceInfo.localHeight * 0.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            floatingActionButton: SizedBox(
              width: deviceInfo.screenWidth * 0.15,
              height: deviceInfo.screenWidth * 0.15,
              child: FloatingActionButton(
                heroTag: 'adminReportButton',
                backgroundColor: Colors.white,
                foregroundColor: ColorsManager.primaryColor,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) =>
                            ShowCreatePostDialogWidget(deviceInfo: deviceInfo),
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    deviceInfo.screenWidth * 0.08,
                  ),
                ),
                elevation: deviceInfo.screenWidth * 0.02,
                mini: deviceInfo.screenWidth < 400,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                child: Icon(
                  Icons.edit_outlined,
                  color: ColorsManager.primaryColor,
                  size: deviceInfo.screenWidth * 0.06,
                ),
              ),
            ),
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          ),
        );
      },
    );
  }

  Widget _buildHeaderSection(DeviceInfo deviceInfo) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          deviceInfo.screenWidth * 0.05,
          deviceInfo.screenHeight * 0.019,
          deviceInfo.screenWidth * 0.035,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(deviceInfo, context),
            Divider(
              height: deviceInfo.localHeight * 0.02,
              thickness: deviceInfo.screenWidth * 0.001,
              color: ColorsManager.greyColor,
            ),
            SizedBox(height: deviceInfo.localHeight * 0.02),
            _buildAnimatedCreatePostWidget(deviceInfo),
            SizedBox(height: deviceInfo.localHeight * 0.02),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCreatePostWidget(DeviceInfo deviceInfo) {
    return SlideTransitionWidget(
      child: CreatePostWidget(deviceInfo: deviceInfo),
    );
  }

  Widget _buildHeader(DeviceInfo deviceInfo, BuildContext context) {
    return HeaderWidget(
      info: deviceInfo,
      onBackPressed: () {},
      titleImageAsset: 'assets/images/Title_img.png',
      extraButtons: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: ColorsManager.primaryColor,
            size: deviceInfo.screenWidth * 0.07,
          ),
          onPressed: () {
            context.pushNamed(Routes.filteringScreen);
          },
        ),
        IconButton(
          icon: Icon(
            Icons.logout,
            color: ColorsManager.primaryColor,
            size: deviceInfo.screenWidth * 0.07,
          ),
          onPressed: () {
            logOutDialog(context, deviceInfo);
          },
        ),
      ],
      isBackButtonVisible: false,
      isAdmin: getIt.get<userMainDetailsCubit>().state.rolesIds!.contains(1),
      isUser: getIt.get<userMainDetailsCubit>().state.rolesIds!.contains(2),
    );
  }

  Widget _buildPostList(DeviceInfo deviceInfo, HomeState state) {
    if (state is PostLoaded || state is PostLoadingMore) {
      final posts =
          state is PostLoaded ? state.posts : (state as PostLoadingMore).posts;
      final total =
          state is PostLoaded ? state.total : (state as PostLoadingMore).total;
      if (total == 0) {
        return const SliverToBoxAdapter(
          child: Center(child: Text('No posts available')),
        );
      }
      return SliverList(
        key: const PageStorageKey('postList'),
        delegate: SliverChildBuilderDelegate((context, index) {
          if (index >= total) return const SizedBox.shrink();
          final isNotMatch =
              posts[index].createdBy.id ==
                      getIt.get<userMainDetailsCubit>().state.userId
                  ? false
                  : true;
          return TweenAnimationWidget(
            index: index,
            deviceInfo: deviceInfo,
            child: PostCardWidget(
              post: posts[index],
              deviceInfo: deviceInfo,
              idNotMatch: isNotMatch,
              onPressedDelete: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.pop();
                  final postId = posts[index].id;
                  getIt.get<HomeCubit>().deletePost(postId);
                  context.pushReplacementNamed(Routes.homePage);
                  CherryToastMsgs.CherryToastSuccess(
                    info: deviceInfo,
                    context: context,
                    title: "Deleted",
                    description: "Post deleted successfully",
                  );
                });
              },
            ),
          );
        }, childCount: posts.length),
      );
    }

    return SliverFillRemaining(
      child: Builder(
        builder: (context) {
          if (state is PostError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              CherryToastMsgs.CherryToastError(
                info: deviceInfo,
                context: context,
                title: "Error",
                description: state.message,
              );
            });
          }
          return state is PostError
              ? SizedBox() // Returning an empty widget instead of the toast
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildLoadingIndicator(DeviceInfo deviceInfo, HomeState state) {
    if (state is PostLoadingMore) {
      return SliverToBoxAdapter(
        child: customShimmer(
          childWidget: Column(
            children: [
              for (int i = 0; i < 2; i++)
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: deviceInfo.screenHeight * 0.01,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: deviceInfo.screenHeight * 0.04,
                        width: deviceInfo.screenWidth * 0.9,
                        color: Colors.grey.shade300,
                      ),
                      SizedBox(height: deviceInfo.screenHeight * 0.01),
                      Container(
                        height: deviceInfo.screenHeight * 0.08,
                        width: deviceInfo.screenWidth * 0.9,
                        color: Colors.grey.shade300,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    }
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
