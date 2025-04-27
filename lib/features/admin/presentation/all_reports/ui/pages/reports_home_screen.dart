import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/helper/extantions.dart';

import '../../../../../../core/Responsive/ui_component/info_widget.dart'
    show InfoWidget;
import '../../../../../../core/di/di.dart';
import '../../../../../../core/routing/routs.dart';
import '../../../../../../core/shared/widgets/animation/tween_animation_widget.dart';
import '../../../../../../core/shared/widgets/custom_drawer_widget.dart';
import '../../../../../../core/shared/widgets/header_widget.dart'
    show HeaderWidget;
import '../../../../../../core/theming/colors.dart';
import '../../../../../../core/theming/styles.dart';
import '../../../../../../core/userMainDetails/userMainDetails_cubit.dart'
    show userMainDetailsCubit;
import '../../../../domain/entities/main_report_entity.dart'
    show MainReportEntity;
import '../../logic/cubit/all_reports_cubit.dart';
import '../widgets/main_report_card.dart';

class ReportsHomeScreen extends StatefulWidget {
  const ReportsHomeScreen({super.key});

  @override
  State<ReportsHomeScreen> createState() => _ReportsHomeScreenState();
}

class _ReportsHomeScreenState extends State<ReportsHomeScreen> {
  //late AllReportsCubit allReportsCubit;
  // vaiables
  List<MainReportEntity> allReports = [];
  final ScrollController scrollController = ScrollController();
  // init state
  @override
  void initState() {
    super.initState();
    //allReportsCubit = getIt<AllReportsCubit>();
    final token = context.read<userMainDetailsCubit>().state.token;

    context.read<AllReportsCubit>().getAllReports({
      'statusId': 1,
    }, token: token!);
    scrollController.addListener(_onScroll);
  }

  // dispose
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final token = context.read<userMainDetailsCubit>().state.token;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      context.read<AllReportsCubit>().loadMoreReports({
        'statusId': 1,
      }, token: token!);
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
            endDrawer: CustomDrawerWidget(inMemberView: false),
            body: RefreshIndicator(
              onRefresh: () async {
                //final token = context.read<userMainDetailsCubit>().state.token;
                context.read<AllReportsCubit>().onRefresh();
                // //context.read<AllReportsCubit>()
                // allReportsCubit.getAllReports(
                //   {'statusId': 1},
                //   token: token!,
                // );
              },
              child: SingleChildScrollView(
                //scroll controller to handle scroll
                controller: scrollController,
                scrollDirection: Axis.vertical,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        deviceInfo.screenWidth * 0.05,
                        deviceInfo.screenHeight * 0.019,
                        deviceInfo.screenWidth * 0.035,
                        0,
                      ),
                      child: HeaderWidget(
                        isAdmin: getIt<userMainDetailsCubit>().state.isAdmin!,
                        isUser: getIt<userMainDetailsCubit>().state.isMember!,
                        isBackButtonVisible: false,
                        info: deviceInfo,
                        onBackPressed: context.pop,
                        titleImageAsset: 'assets/images/Title_img.png',
                        searchIconRoute: Routes.reportsFilterScreen,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: deviceInfo.screenWidth * 0.06,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Posts Reports',
                            style: TextStyles.inter18Regularblack.copyWith(
                              fontSize: deviceInfo.screenWidth * 0.07,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: deviceInfo.screenHeight * 0.01),
                    BlocBuilder<AllReportsCubit, AllReportsState>(
                      builder: (context, state) {
                        if (state is AllReportsLoading && allReports.isEmpty) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: ColorsManager.primaryColor,
                            ),
                          );
                        } else if (state is AllReportsLoaded) {
                          allReports = state.allReports;

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                allReports.length + (state.hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == allReports.length && state.hasMore) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return TweenAnimationWidget(
                                deviceInfo: deviceInfo,
                                index: index,
                                child: MainReportCard(
                                  deviceInfo: deviceInfo,
                                  postTitle: allReports[index].postTitle,
                                  reportedBy: allReports[index].reportedBy,
                                  postId: allReports[index].postId,
                                  reportDate: allReports[index].reportedOn,
                                  reportCategory: allReports[index].category,
                                  reportStatus: allReports[index].status,
                                  reportId: allReports[index].reportId,
                                ),
                              );
                            },
                          );
                        } else if (state is AllReportsConnectionError) {
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
                        } else if (state is AllReportsEmpty) {
                          return Center(child: Text('No reports found'));
                        } else if (state is AllReportsStatusCodeError) {
                          return Center(child: Text('Status code error'));
                        } else if (state is AllReportsError) {
                          return Center(child: Text('Something went wrong'));
                        } else {
                          return Center(child: CircularProgressIndicator());
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
