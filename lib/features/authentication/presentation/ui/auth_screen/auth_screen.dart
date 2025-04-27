import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cherry_toast/cherry_toast.dart';
import '../../../../../core/Responsive/ui_component/info_widget.dart';
import '../../../../../core/routing/routs.dart';
import '../../../../../core/shared/widgets/cherryToast/CherryToastMsgs.dart';
import '../../../../../core/userMainDetails/userMainDetails_cubit.dart';
import '../../logic/auth_cubit.dart';
import '../../logic/auth_state.dart';
import '../widgets/customButton.dart' show CustomButton;
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: InfoWidget(
        builder: (context, info) {
          return BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthLogInTokenRetrivedState) {
                if (context.read<userMainDetailsCubit>().state.isAdmin ==
                    true) {
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.reportsHomeScreen,
                  );
                } else if (context
                        .read<userMainDetailsCubit>()
                        .state
                        .isMember ==
                    true) {
                  Navigator.pushReplacementNamed(context, Routes.homePage);
                }
              }

              if (state is AuthRegisterSuccessState) {
                CherryToast.success(
                  title: Text("Success", style: TextStyle(color: Colors.white)),
                  toastDuration: Duration(seconds: 3),
                  borderRadius: info.screenWidth * 0.04,
                  backgroundColor: Colors.green,
                  shadowColor: Colors.black45,
                  animationDuration: Duration(milliseconds: 300),
                  animationType: AnimationType.fromTop,
                  autoDismiss: true,
                  description: Text(
                    'Successfully Registered',
                    style: TextStyle(color: Colors.white70),
                  ),
                ).show(context);

                context.read<AuthCubit>().toggleAuth();
              }

              if (state is AuthLogInErrorState) {
                CherryToastMsgs.CherryToastError(
                  info: info,
                  context: context,
                  title: 'Sign In Failed',
                  description: state.message,
                );
              }
            },
            builder: (context, state) {
              return Scaffold(
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: info.screenWidth * 0.1,
                      end: info.screenWidth * 0.1,
                      top: info.screenHeight * 0.15,
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/images/fullLogo.png",
                            height: info.screenHeight * 0.1,
                          ),
                        ),
                        AuthHeader(
                          isSignIn: context.read<AuthCubit>().IsSignIn,
                          onToggle:
                              () => context.read<AuthCubit>().toggleAuth(),
                        ),
                        Container(
                          constraints: BoxConstraints(
                            minHeight: info.screenHeight * 0.47,
                          ),
                          margin: EdgeInsetsDirectional.only(
                            top: info.screenHeight * 0.016,
                          ),
                          child: Column(
                            children: [
                              context.read<AuthCubit>().IsSignIn
                                  ? SignInForm()
                                  : SignUpForm(),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: info.screenWidth * 0.6,
                          child: CustomButton(
                            childWidget:
                                state is AuthLoadingState
                                    ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : Text(
                                      context.read<AuthCubit>().IsSignIn
                                          ? "Login"
                                          : "Join Now",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: info.screenWidth * 0.04,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            onPressed: () async {
                              if (context.read<AuthCubit>().IsSignIn) {
                                context.read<AuthCubit>().logIn(context);
                              } else {
                                context.read<AuthCubit>().signUp(context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AuthHeader extends StatelessWidget {
  final bool isSignIn;
  final VoidCallback onToggle;

  const AuthHeader({super.key, required this.isSignIn, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white, // Transparent to show SafeArea effect
        statusBarIconBrightness:
            Brightness.dark, // Use Brightness.light for white icons
      ),
    );

    return InfoWidget(
      builder: (context, info) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onToggle,
              child: Text(
                "Sign in",
                style: TextStyle(
                  fontSize: info.screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: isSignIn ? Colors.black : Colors.grey,
                ),
              ),
            ),
            SizedBox(width: info.screenWidth * 0.05),
            GestureDetector(
              onTap: onToggle,
              child: Text(
                "Sign up",
                style: TextStyle(
                  fontSize: info.screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                  color: isSignIn ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
