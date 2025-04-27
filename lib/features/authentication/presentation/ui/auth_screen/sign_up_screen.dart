import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/Responsive/ui_component/info_widget.dart'
    show InfoWidget;
import '../../../../../core/helper/FormValidator/Validator.dart'
    show ValidatorHelper;
import '../../logic/auth_cubit.dart' show AuthCubit;
import '../widgets/customTextField.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    String? retypePasswordValidator(String? value) {
      return ValidatorHelper.isPasswordConfirmed(
        context.read<AuthCubit>().passController.text,
        value,
      );
    }

    return InfoWidget(
      builder: (context, info) {
        return Column(
          spacing: info.screenHeight * 0.016,
          children: [
            CustomTextField(
              label: "First Name",
              hintText: "Omar",
              controller: context.read<AuthCubit>().firstNameController,
              formValidator: ValidatorHelper.isNotEmpty,
            ),
            CustomTextField(
              label: "Last Name",
              hintText: "Ahmed",
              controller: context.read<AuthCubit>().lastNameController,
              formValidator: ValidatorHelper.isNotEmpty,
            ),
            CustomTextField(
              label: "Email",
              hintText: "user123@example.com",
              controller: context.read<AuthCubit>().emailController,
              formValidator: ValidatorHelper.combineValidators([
                ValidatorHelper.isNotEmpty,
                ValidatorHelper.isValidEmail,
              ]),
            ),
            CustomTextField(
              label: "Phone",
              hintText: "01234567898",
              controller: context.read<AuthCubit>().phoneController,
              formValidator: ValidatorHelper.combineValidators([
                ValidatorHelper.isNotEmpty,
                ValidatorHelper.isValidPhone,
              ]),
            ),
            CustomTextField(
              label: "Password",
              hintText: "********",
              isPassword: true,
              controller: context.read<AuthCubit>().passController,
              formValidator: ValidatorHelper.combineValidators([
                ValidatorHelper.isNotEmpty,
                ValidatorHelper.isValidPassword,
              ]),
            ),
            Row(
              children: [
                SizedBox(
                  width: info.screenWidth * 0.63,
                  child: CustomTextField(
                    label: "Confirm Password",
                    hintText: "********",
                    isPassword: true,
                    controller: context.read<AuthCubit>().retypePassController,
                    formValidator: ValidatorHelper.combineValidators([
                      ValidatorHelper.isNotEmpty,
                      retypePasswordValidator,
                    ]),
                  ),
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(
                    start: info.screenWidth * 0.03,
                  ),
                  padding: EdgeInsetsDirectional.only(
                    start: info.screenWidth * 0.012,
                  ),
                  width: info.screenWidth * 0.14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      info.screenWidth * 0.03,
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 4),
                        color: Colors.black45,
                        spreadRadius: info.screenWidth * 0.0001,
                        blurRadius: info.screenWidth * 0.02,
                      ),
                    ],
                  ),
                  child: DropdownButton<String>(
                    value:
                        context
                            .read<AuthCubit>()
                            .selectedGender, // Current selected value
                    onChanged: (String? newValue) {
                      context.read<AuthCubit>().selectedGender = newValue!;
                    },
                    items:
                        context.read<AuthCubit>().genderIcons.entries.map((
                          entry,
                        ) {
                          return DropdownMenuItem<String>(
                            value: entry.key,
                            child: Row(
                              children: [
                                entry.value, // Display gender icon
                                SizedBox(width: info.screenWidth * 0.01),
                                Text(entry.key),
                              ],
                            ),
                          );
                        }).toList(),

                    selectedItemBuilder: (BuildContext context) {
                      return context.read<AuthCubit>().genderIcons.entries.map((
                        entry,
                      ) {
                        return entry.value;
                      }).toList();
                    },
                    borderRadius: BorderRadius.circular(
                      info.screenWidth * 0.03,
                    ),
                    dropdownColor: Colors.white,
                    underline: Container(),
                    menuWidth: info.screenWidth * 0.34,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),

            SizedBox(height: info.screenHeight * 0.00001),
          ],
        );
      },
    );
  }
}
