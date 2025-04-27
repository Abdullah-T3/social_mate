import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/helper/extantions.dart';

import '../../../../core/Responsive/ui_component/info_widget.dart';
import '../../../../core/di/di.dart' show getIt;
import '../../../../core/routing/routs.dart';
import '../../../../core/theming/colors.dart';
import '../../../authentication/presentation/logic/auth_cubit.dart'
    show AuthCubit;
import '../../../authentication/presentation/ui/widgets/bottom_buttons.dart';
import '../logic/on_boarding_cubit.dart';
import 'on_board_content.dart';
import 'widgets/on_board_model.dart';
import 'widgets/page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  final List<OnboardModel> pages = [
    OnboardModel(
      image: "assets/images/onboarding_firstScreen.png",
      title: "Find Friends & Get Inspiration",
      description: "",
    ),
    OnboardModel(
      image: "assets/images/onboarding_secondScreen.png",
      title: "Meet Awesome People & Enjoy Yourself",
      description: "",
    ),
    OnboardModel(
      image: "assets/images/onboarding_thirdScreen.png",
      title: "Hangout with Friends",
      description: "",
    ),
  ];

  OnboardingScreen({super.key});

  void _nextPage(BuildContext context) {
    final currentIndex = context.read<OnboardingCubit>().state;
    if (currentIndex < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      context.read<OnboardingCubit>().updatePage(currentIndex + 1);
    } else {
      // Navigate to another screen
      AuthCubit(getIt()).IsSignIn = false;
      context.pushReplacementNamed(Routes.AuthScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: InfoWidget(
        builder: (context, info) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: ColorsManager.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: BlocBuilder<OnboardingCubit, int>(
                      builder: (context, currentPage) {
                        return PageView.builder(
                          controller: _pageController,
                          onPageChanged:
                              (index) => context
                                  .read<OnboardingCubit>()
                                  .updatePage(index),
                          itemCount: pages.length,
                          itemBuilder: (context, index) {
                            return OnboardContent(page: pages[index]);
                          },
                        );
                      },
                    ),
                  ),
                  BlocBuilder<OnboardingCubit, int>(
                    builder: (context, currentPage) {
                      return PageIndicator(
                        currentPage: currentPage,
                        pageCount: pages.length,
                      );
                    },
                  ),
                  SizedBox(height: info.screenHeight * 0.03),
                  BottomButtons(onNext: () => _nextPage(context)),
                  SizedBox(height: info.screenHeight * 0.03),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
