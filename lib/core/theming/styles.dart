import 'package:flutter/material.dart';

import 'colors.dart';

class TextStyles {
  static const inter18Bold = TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Inter');

  static const inter14RegularBlue = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: 'Inter',
    color: ColorsManager.primaryColor,
  );
  static const inter14BoldBlue = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    fontFamily: 'Inter',
    color: ColorsManager.primaryColorBold,
  );
  static const inter14Regular = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: 'Inter',
  );
  static final inter18RegularWithOpacity = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    fontFamily: 'Inter',
    color: Colors.black.withOpacity(0.8),
  );
  static const inter18BoldBlack = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: 'Inter',
    color: Colors.black,
  );
  static const inter18Regularblack = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    fontFamily: 'Inter',
    color: Colors.black,
  );
  static const inter16Bold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: 'Inter',
  );
  static const inter16Regular = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: 'Inter',
  );
  static TextStyle inter16RegularBlackWithOpacity = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: 'Inter',
    color: Colors.black.withOpacity(0.5),
  );
  // created by Marwan
  // static const inter18BoldBlack = TextStyle(
  //   fontSize: 18,
  //   fontWeight: FontWeight.w900,
  //   fontFamily: 'Inter',
  //   color: Colors.black,
  // );
  static const inter16RegularBlack = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: 'Inter',
    color: Colors.black,
  );
  static const inter18MediumBlack = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    fontFamily: 'Inter',
    color: Colors.black,
  );
}

class TextFieldStyles {
  static final inputDecorationTitleFiled = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: ColorsManager.primaryColor.withOpacity(0.5),
      ),
      borderRadius: BorderRadius.circular(100),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsManager.primaryColor.withOpacity(0.5)),
      borderRadius: BorderRadius.circular(100),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsManager.primaryColor.withOpacity(0.5)),
      borderRadius: BorderRadius.circular(100),
    ),
  );
  static final inputDecorationContentFiled = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsManager.primaryColor.withOpacity(0.5)),
      borderRadius: BorderRadius.circular(100),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsManager.primaryColor.withOpacity(0.5)),
      borderRadius: BorderRadius.circular(100),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorsManager.primaryColor.withOpacity(0.5)),
      borderRadius: BorderRadius.circular(100),
    ),
  );
}

// created by Marwan for filtering
InputDecoration formInputStyle({required String label, required String hintText, required VoidCallback onPressed, required TextEditingController controller}) {
  return InputDecoration(
    suffixIcon: controller.text.isNotEmpty
        ? IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.clear_rounded,
              color: ColorsManager.redColor,
            ),
          )
        : null,
    isDense: true,
    hintText: hintText,
    hintStyle: TextStyles.inter16RegularBlack.copyWith(color: Colors.grey[500],fontWeight: FontWeight.w500),
    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
    // floatingLabelAlignment: FloatingLabelAlignment.start,
    // floatingLabelBehavior: FloatingLabelBehavior.always,
    // alignLabelWithHint: false,
    label: Text(
      label,
      style: TextStyles.inter18MediumBlack.copyWith(fontSize: 15),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none

      // BorderSide(
      //   color: ColorsManager.primaryColor,
      //   width: 1,
      // ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      // borderSide: BorderSide(
      //   color: const Color.fromARGB(255, 1, 14, 27),
      //   width: 1,
      // ),
        borderSide: BorderSide.none
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: const Color.fromARGB(255, 1, 14, 27),
        width: 1,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: Colors.red,
        width: 1,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: Colors.red,
        width: 1,
      ),
    ),
    filled: true,
    fillColor: ColorsManager.lightGreyColor,
    errorStyle: TextStyle(height: 1),
  );
}
