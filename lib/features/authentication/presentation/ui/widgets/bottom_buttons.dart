import 'package:flutter/material.dart';
import 'package:social_mate/core/helper/extantions.dart';

import '../../../../../core/Responsive/ui_component/info_widget.dart'
    show InfoWidget;
import '../../../../../core/di/di.dart';
import '../../../../../core/routing/routs.dart';
import '../../../../../core/theming/colors.dart' show ColorsManager;
import '../../logic/auth_cubit.dart';

class BottomButtons extends StatelessWidget {
  final VoidCallback onNext;

  const BottomButtons({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return InfoWidget(
      builder: (context, info) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: info.screenWidth * 0.08),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      info.screenWidth * 0.04,
                    ),
                  ),
                  minimumSize: Size(double.infinity, info.screenHeight * 0.057),
                ),
                child: Text(
                  "Join Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: info.screenWidth * 0.041,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: info.screenHeight * 0.015),
              TextButton(
                onPressed: () {
                  // Navigate to Login
                  AuthCubit(getIt()).IsSignIn = true;
                  context.pushReplacementNamed(Routes.AuthScreen);
                },
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: info.screenWidth * 0.04,
                    color: ColorsManager.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
