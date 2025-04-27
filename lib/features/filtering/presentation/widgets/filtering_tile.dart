import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/features/filtering/presentation/cubit/filtering_cubit.dart';
import 'package:social_mate/features/filtering/presentation/cubit/sharing_data/sharing_data_cubit.dart';
import 'package:social_mate/features/filtering/presentation/widgets/drop_menu.dart';
import 'package:social_mate/features/filtering/presentation/widgets/filtering_button.dart';
import 'package:social_mate/features/filtering/presentation/widgets/form_text_input.dart';
import 'package:social_mate/features/filtering/presentation/widgets/helper_functions/date_picker_helper.dart';
import 'package:social_mate/features/filtering/presentation/widgets/helper_functions/form_field_validator.dart';
import 'package:social_mate/features/filtering/presentation/widgets/post_owner_dialog.dart';

import '../../../../core/Responsive/ui_component/info_widget.dart';
import '../../../../core/di/di.dart';
import '../../../../core/theming/colors.dart' show ColorsManager;
import '../../../../core/theming/styles.dart';
import '../../../../core/userMainDetails/userMainDetails_cubit.dart';
import '../../../posts/presentation/homePage/logic/cubit/home_cubit_cubit.dart';
import '../cubit/filtered_users/filtered_users_cubit.dart';

class FilteringTile extends StatefulWidget {
  final FilteringCubit filteringCubit;
  final HomeCubit homeCubit;
  final SharingDataCubit sharingDataCubit;
  final FilteredUsersCubit filteredUsersCubit;

  const FilteringTile({
    super.key,
    required this.filteringCubit,
    required this.sharingDataCubit,
    required this.filteredUsersCubit,
    required this.homeCubit,
  });

  @override
  State<FilteringTile> createState() => _FilteringTileState();
}

class _FilteringTileState extends State<FilteringTile> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController postOwnerController = TextEditingController();
  final TextEditingController dialogeController = TextEditingController();
  final TextEditingController createdFromController = TextEditingController();
  final TextEditingController createdToController = TextEditingController();
  final TextEditingController sortedByItemController = TextEditingController();
  final TextEditingController orderedByItemController = TextEditingController();
  final FocusNode titleNode = FocusNode();
  final FocusNode postOwnerNode = FocusNode();
  final FocusNode createdFromNode = FocusNode();
  final FocusNode createdToNode = FocusNode();
  final FocusNode sortedByNode = FocusNode();
  final FocusNode orderedByNode = FocusNode();
  final FocusNode noNode = FocusNode();
  final DateTime firstDate = DateTime(2021, 1, 1);
  final DateTime lastDate = DateTime(2026, 1, 1);
  DateTime? selectedFromDate;
  DateTime? selectedToDate;
  late String sortedByValue = 'None';
  late String orderedByValue = 'None';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> queryParameters;
  late FilteringCubit filteringCubit;
  late HomeCubit homeCubit;
  late String postOwnerId = '';
  bool isExpanded = false; // Manage the expanded state here

  @override
  void dispose() {
    titleController.dispose();
    createdFromController.dispose();
    createdToController.dispose();
    sortedByItemController.dispose();
    titleNode.dispose();
    postOwnerNode.dispose();
    createdFromNode.dispose();
    createdToNode.dispose();
    sortedByNode.dispose();
    noNode.dispose();
    postOwnerController.dispose();
    homeCubit.close();
    super.dispose();
  }

  @override
  void initState() {
    filteringCubit = widget.filteringCubit;
    homeCubit = widget.homeCubit;

    super.initState();

    sortedByItemController.addListener(() {
      if (sortedByItemController.text.isEmpty) {
        sortedByValue = '';
      }
    });

    orderedByItemController.addListener(() {
      if (orderedByItemController.text.isEmpty) {
        orderedByValue = '';
      }
    });

    postOwnerController.addListener(() {
      if (postOwnerController.text.isEmpty) {
        postOwnerId = '';
      }
    });
  }

  void Function() sortedByOnSelected(String? value) {
    FocusScope.of(context).requestFocus(orderedByNode);
    setState(() {
      sortedByValue = value ?? '';
    });
    return () {};
  }

  void Function() orderedByOnSelected(String? value) {
    FocusScope.of(context).unfocus();
    setState(() {
      orderedByValue = value ?? '';
    });
    return () {};
  }

  void _handleFromDateSelected(DateTime newDate) {
    setState(() {
      selectedFromDate = newDate;
      createdFromController.text = newDate.toString().split(' ')[0];
    });
  }

  void _handleToDateSelected(DateTime newDate) {
    setState(() {
      selectedToDate = newDate;
      createdToController.text = newDate.toString().split(' ')[0];
    });
  }

  void Function() onDateFromChanged(String? value) {
    setState(() {
      if (createdFromController.text.isEmpty) {
        selectedFromDate = null;
      }
    });

    return () {};
  }

  void Function() onDateToChanged(String? value) {
    setState(() {
      if (createdToController.text.isEmpty) {
        selectedToDate = null;
      }
    });
    return () {};
  }

  void _onFilterButtonPressed() async {
    FocusScope.of(context).unfocus();

    final token = getIt<userMainDetailsCubit>().state.token;

    if (_formKey.currentState!.validate()) {
      queryParameters = {
        if (titleController.text.isNotEmpty) 'title': titleController.text,
        if (postOwnerId.isNotEmpty) 'createdById': postOwnerId,
        if (sortedByValue.isNotEmpty && sortedByValue != 'None')
          'orderBy': sortedByValue,
        if (createdFromController.text.isNotEmpty)
          'createdOnFrom': createdFromController.text,
        if (createdToController.text.isNotEmpty)
          'createdOnTo': createdToController.text,
        if (orderedByValue.isNotEmpty && orderedByValue != 'None')
          'orderDir': orderedByValue,
      };

      context.read<SharingDataCubit>().updateQueryParams(queryParameters);
      context.read<SharingDataCubit>().updatePosts([]);
      filteringCubit.getFilteredPosts(
        queryParameters: queryParameters,
        token: token!,
      );
      if (filteringCubit.state is FilteredPostsIsLoaded) {
        print('expandedd');
        isExpanded = false;
        setState(() {});
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return InfoWidget(
      builder: (context, deviceInfo) {
        return SingleChildScrollView(
          child: Container(
            width: deviceInfo.screenWidth,
            padding: EdgeInsets.symmetric(
              horizontal: deviceInfo.screenWidth * 0.05,
              vertical: deviceInfo.screenWidth * 0.02,
            ),
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 2),
                  blurRadius: deviceInfo.screenWidth * 0.02,
                  spreadRadius: deviceInfo.screenWidth * 0.015,
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                deviceInfo.screenWidth * 0.04,
              ),

              border: Border.all(
                color: ColorsManager.primaryColor,
                width: deviceInfo.screenWidth * 0.0015,
              ),
            ),
            child: ExpansionPanelList(
              elevation: 0,
              expandIconColor: ColorsManager.primaryColor,
              expandedHeaderPadding: EdgeInsets.all(
                deviceInfo.screenWidth * 0.01,
              ),
              expansionCallback: (panelIndex, isExpanded) {
                setState(() {
                  this.isExpanded = !this.isExpanded; // Toggle the state
                });
              },
              children: [
                ExpansionPanel(
                  backgroundColor: ColorsManager.whiteColor,
                  isExpanded: isExpanded, // Bind the state to the panel
                  headerBuilder: (context, isExpanded) {
                    return ListTile(
                      title: Text(
                        'Filter Options',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                  body: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FormTextInput(
                          nextNode: postOwnerNode,
                          label: 'Title',
                          hintText: 'Enter post title',
                          focusNode: titleNode,
                          controller: titleController,
                          screenWidth: deviceInfo.screenWidth,
                          screenHeight: deviceInfo.screenHeight,
                        ),
                        FormTextInput(
                          controller: postOwnerController,
                          nextNode: createdFromNode,
                          focusNode: postOwnerNode,
                          label: 'Post Owner',
                          hintText: 'Click to select post owner',
                          onTap:
                              () => showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: PostOwnerDialog(
                                      context: context,
                                      width: deviceInfo.screenWidth * 0.9,
                                      height: deviceInfo.screenHeight * 0.5,
                                      filteredUsersCubit:
                                          widget.filteredUsersCubit,
                                      parentController: postOwnerController,
                                      dialogController: dialogeController,
                                      onPostOwnerSelected: (selectedId) {
                                        setState(() {
                                          postOwnerId = selectedId;
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                          screenWidth: deviceInfo.screenWidth,
                          screenHeight: deviceInfo.screenHeight,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: FormTextInput(
                                label: 'Created From',
                                hintText:
                                    selectedFromDate != null
                                        ? selectedFromDate.toString().split(
                                          ' ',
                                        )[0]
                                        : 'Select a date',
                                focusNode: createdFromNode,
                                nextNode: createdToNode,
                                controller: createdFromController,
                                onChanged: onDateFromChanged,
                                onTap: () {
                                  showFromDatePicker(
                                    onDateSelected: _handleFromDateSelected,
                                    context: context,
                                    controller: createdFromController,
                                    firstDate: firstDate,
                                    lastDate: lastDate,
                                  );
                                },
                                validator: (value) {
                                  return validateDateRange(
                                    createdFromController,
                                    createdToController,
                                  );
                                },
                                screenWidth: deviceInfo.screenWidth,
                                screenHeight: deviceInfo.screenHeight,
                              ),
                            ),
                            SizedBox(width: deviceInfo.screenHeight * 0.03),
                            Expanded(
                              child: FormTextInput(
                                label: 'Created To',
                                hintText:
                                    selectedToDate != null
                                        ? selectedToDate.toString().split(
                                          ' ',
                                        )[0]
                                        : 'Select a date',
                                focusNode: createdToNode,
                                nextNode: sortedByNode,
                                controller: createdToController,
                                onChanged: onDateToChanged,
                                onTap: () {
                                  showToDatePicker(
                                    context: context,
                                    controller: createdToController,
                                    firstDate: firstDate,
                                    lastDate: lastDate,
                                    onDateSelected: _handleToDateSelected,
                                  );
                                },
                                validator: (value) {
                                  return validateDateRange(
                                    createdFromController,
                                    createdToController,
                                  );
                                },
                                screenWidth: deviceInfo.screenWidth,
                                screenHeight: deviceInfo.screenHeight,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: deviceInfo.screenWidth * 0.4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sorted By :',
                                    style: TextStyles.inter14Regular,
                                  ),
                                  DropMenu(
                                    selectedValue: sortedByValue,
                                    validator: (value) {
                                      return validateSortedBy(
                                        sortedByValue,
                                        orderedByValue,
                                      );
                                    },
                                    onSelected: sortedByOnSelected,
                                    menuLabel: 'Sorted By',
                                    sortedByNode: sortedByNode,
                                    menuItemController: sortedByItemController,
                                    screenWidth: deviceInfo.screenWidth,
                                    screenHeight: deviceInfo.screenHeight,
                                    sortedByEntries: [
                                      DropdownMenuEntry(
                                        value: 'None',
                                        label: 'None',
                                      ),
                                      DropdownMenuEntry(
                                        value: 'TITLE',
                                        label: 'Title',
                                      ),
                                      DropdownMenuEntry(
                                        value: 'POST_OWNER',
                                        label: 'Post Owner',
                                      ),
                                      DropdownMenuEntry(
                                        value: 'CREATION_DATE',
                                        label: 'Creation Date',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: deviceInfo.screenWidth * 0.4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ordered By :',
                                    style: TextStyles.inter14Regular,
                                  ),
                                  DropMenu(
                                    selectedValue: orderedByValue,
                                    onSelected: orderedByOnSelected,
                                    menuLabel: 'Order Direction',
                                    sortedByNode: orderedByNode,
                                    menuItemController: orderedByItemController,
                                    screenWidth: deviceInfo.screenWidth,
                                    screenHeight: deviceInfo.screenHeight,
                                    sortedByEntries: [
                                      DropdownMenuEntry(
                                        value: 'None',
                                        label: 'None',
                                      ),
                                      DropdownMenuEntry(
                                        value: 'ASC',
                                        label: 'Ascending',
                                      ),
                                      DropdownMenuEntry(
                                        value: 'DESC',
                                        label: 'Descending',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: deviceInfo.screenHeight * 0.02,
                          ),
                          child: FilteringButton(
                            onPressed: _onFilterButtonPressed,
                            screenWidth: deviceInfo.screenWidth,
                            screenHeight: deviceInfo.screenHeight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
