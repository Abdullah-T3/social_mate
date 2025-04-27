import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String? validateTextInput(
  String sortedByValue,
  TextEditingController titleController,
  TextEditingController postOwnerController,
  TextEditingController createdFromController,
  TextEditingController createdToController,
  TextEditingController orderedByController,
) {
  if ((sortedByValue.isEmpty) &&
      titleController.text.isEmpty &&
      postOwnerController.text.isEmpty &&
      createdFromController.text.isEmpty &&
      createdToController.text.isEmpty &&
      orderedByController.text.isEmpty) {
    return null;
  }
  if ((sortedByValue.isEmpty) && orderedByController.text.isNotEmpty) {
    return 'you neet to select a value here';
  }
  return null;
}

String? validateSortedBy(String sortedByValue, String orderedByValue) {
  if (sortedByValue == 'None' && orderedByValue != 'None') {
    return 'please choose sorting type ';
  }
  return null;
}

String? validateDateRange(
    TextEditingController fromController, TextEditingController toController) {
  DateFormat format = DateFormat('yyyy-MM-dd');

  // Allow users to select only one date without error
  if (fromController.text.isEmpty || toController.text.isEmpty) {
    return null; // No validation needed if one of them is not selected
  }

  DateTime? fromDate;
  DateTime? toDate;

  try {
    fromDate = format.parse(fromController.text);
    toDate = format.parse(toController.text);
  } catch (e) {
    return 'Invalid date format';
  }

  if (fromDate == toDate) {
    return 'Cannot be the same';
  }

  if (toDate.isBefore(fromDate)) {
    return 'Wrong date range';
  }

  return null; // Return null if the validation passes
}
