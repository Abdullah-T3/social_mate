import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/routing/routs.dart';

import '../../features/admin/presentation/Filter/logic/report_filter_cubit.dart';
import '../../features/admin/presentation/Filter/ui/reportsFilter_screen.dart';
import '../../features/admin/presentation/all_reports/logic/cubit/all_reports_cubit.dart';
import '../../features/admin/presentation/all_reports/ui/pages/reports_home_screen.dart';
import '../../features/admin/presentation/report_details/logic/report_details_cubit.dart';
import '../../features/admin/presentation/report_details/ui/report_detials_screen.dart';
import '../../features/authentication/presentation/logic/auth_cubit.dart';
import '../../features/authentication/presentation/ui/auth_screen/auth_screen.dart';
import '../../features/filtering/presentation/cubit/filtered_users/filtered_users_cubit.dart';
import '../../features/filtering/presentation/cubit/filtering_cubit.dart';
import '../../features/filtering/presentation/cubit/sharing_data/sharing_data_cubit.dart';
import '../../features/filtering/presentation/pages/filtering_screen.dart';
import '../../features/on_boarding/presentation/ui/onboarding_screen.dart';
import '../../features/posts/presentation/homePage/logic/cubit/home_cubit_cubit.dart';
import '../../features/posts/presentation/homePage/ui/homePage_view.dart';
import '../../features/posts/presentation/postDetails/presentation/logic/post_details_cubit.dart';
import '../../features/posts/presentation/postDetails/presentation/ui/postDetailsScreen.dart';
import '../../features/splash_screen/presentation/ui/splash_screen.dart';
import '../di/di.dart';

class AppRouts {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case Routes.onBordingScreen:
        return MaterialPageRoute(builder: (context) => OnboardingScreen());
      case Routes.AuthScreen:
        return MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                create: (context) => getIt<AuthCubit>(),
                child: AuthScreen(),
              ),
        );
      case Routes.homePage:
        return MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                create: (context) => getIt<HomeCubit>(),
                child: HomepageView(),
              ),
        );
      case Routes.filteringScreen:
        return MaterialPageRoute(
          builder:
              (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<FilteringCubit>(
                    create: (context) => getIt<FilteringCubit>(),
                  ),
                  BlocProvider<SharingDataCubit>(
                    create: (context) => SharingDataCubit(),
                  ),
                  BlocProvider<HomeCubit>(
                    create: (context) => getIt<HomeCubit>(),
                  ),
                  BlocProvider<FilteredUsersCubit>(
                    create: (context) => getIt<FilteredUsersCubit>(),
                  ),
                ],
                child: FilteringScreen(),
              ),
        );
      case Routes.postDetailsScreen:
        return MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                create: (context) => getIt<PostDetailsCubit>(),
                child: post_details_screen(),
              ),
        );
      // admin
      case Routes.adminReportScreen:
        return MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                create: (context) => getIt<ReportDetailsCubit>(),
                child: ReportDetailsScreen(),
              ),
        );

      case Routes.reportsFilterScreen:
        return MaterialPageRoute(
          builder:
              (context) => BlocProvider(
                create: (context) => getIt<ReportFilterCubit>(),
                child: reportsFilterScreen(),
              ),
        );
      case Routes.reportsHomeScreen:
        return MaterialPageRoute(
          builder:
              (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => getIt<ReportDetailsCubit>(),
                  ),
                  BlocProvider(create: (context) => getIt<AllReportsCubit>()),
                ],
                child: ReportsHomeScreen(),
              ),
        );
      default:
        return null;
    }
  }
}
