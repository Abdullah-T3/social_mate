import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/Responsive/ui_component/info_widget.dart';
import '../../../../core/di/di.dart';
import '../../../../core/userMainDetails/userMainDetails_cubit.dart';
import '../../../admin/presentation/all_reports/logic/cubit/all_reports_cubit.dart';
import '../../../admin/presentation/all_reports/ui/pages/reports_home_screen.dart';
import '../../../admin/presentation/report_details/logic/report_details_cubit.dart';
import '../../../on_boarding/presentation/ui/onboarding_screen.dart';
import '../../../posts/presentation/homePage/logic/cubit/home_cubit_cubit.dart';
import '../../../posts/presentation/homePage/ui/homePage_view.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            if (context.read<userMainDetailsCubit>().state.token != null) {
              Future.delayed(Duration(seconds: 3));
              if (context.read<userMainDetailsCubit>().state.isAdmin == true) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => getIt<ReportDetailsCubit>(),
                    ),
                    BlocProvider(create: (context) => getIt<AllReportsCubit>()),
                  ],
                  child: ReportsHomeScreen(),
                );
              } else if (context.read<userMainDetailsCubit>().state.isMember ==
                  true) {
                return BlocProvider(
                  create: (context) => getIt<HomeCubit>(),
                  child: HomepageView(),
                );
              } else {
                return BlocProvider(
                  create: (context) => getIt<HomeCubit>(),
                  child: HomepageView(),
                );
              }
            } else {
              return OnboardingScreen();
            }
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation, // Fade animation
              child: child,
            );
          },
          transitionDuration: const Duration(
            milliseconds: 1000,
          ), // Adjust the duration
        ),
      );
    });

    return InfoWidget(
      builder: (context, deviceInfo) {
        return Scaffold(
          body: Container(
            color: Colors.white,
            padding: EdgeInsetsDirectional.only(
              top: deviceInfo.screenHeight * 0.2,
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/splash_screen.png',
                  width: deviceInfo.screenWidth,
                  height: deviceInfo.screenHeight * 0.44,
                ),

                Image.asset(
                  'assets/images/fullLogo.png',
                  width: deviceInfo.screenWidth * 0.65,
                  height: deviceInfo.screenHeight * 0.1,
                ),

                SizedBox(height: deviceInfo.screenHeight * 0.14),
                Image.asset(
                  'assets/images/ZagSystemsLogo.png',
                  width: deviceInfo.screenWidth * 0.62,
                  height: deviceInfo.screenHeight * 0.1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
