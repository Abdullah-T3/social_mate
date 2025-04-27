import 'package:flutter/material.dart';

import '../../../../core/theming/styles.dart';

/// should be statless
class FormTextInput extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String label;
  final String hintText;
  final FocusNode focusNode;
  final FocusNode? nextNode;
  final TextEditingController controller;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool canRequestFucos;
  const FormTextInput({
    super.key,
    required this.label,
    required this.hintText,
    required this.focusNode,
    this.nextNode,
    required this.controller,
    this.onTap,
    this.validator,
    required this.screenWidth,
    required this.screenHeight,
    this.onChanged,
    this.canRequestFucos = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: TextFormField(
        canRequestFocus: canRequestFucos,
        onChanged: onChanged,
        validator: validator,
        controller: controller,
        focusNode: focusNode,
        minLines: 1,
        decoration: formInputStyle(
          hintText: hintText,
          label: label,
          onPressed: () {
            controller.clear();
          },
          controller: controller,
        ),

        onTap: onTap,
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        onFieldSubmitted: (value) {
          if (nextNode != null) FocusScope.of(context).requestFocus(nextNode);
        },
      ),
    );
  }
}
