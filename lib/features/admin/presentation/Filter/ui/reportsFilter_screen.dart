import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_mate/core/helper/extantions.dart';

import '../../../../../core/Responsive/Models/device_info.dart' show DeviceInfo;
import '../../../../../core/Responsive/ui_component/info_widget.dart'
    show InfoWidget;
import '../../../../../core/shared/widgets/header_widget.dart';
import '../../../../../core/theming/colors.dart';
import '../../../../../core/theming/styles.dart' show TextStyles;
import '../../../../filtering/presentation/widgets/form_text_input.dart'
    show FormTextInput;
import '../../../../filtering/presentation/widgets/helper_functions/form_field_validator.dart'
    show validateDateRange;
import '../../all_reports/ui/widgets/main_report_card.dart' show MainReportCard;
import '../logic/report_filter_cubit.dart';

class reportsFilterScreen extends StatefulWidget {
  @override
  State<reportsFilterScreen> createState() => _reportsFilterScreenState();
}

class _reportsFilterScreenState extends State<reportsFilterScreen> {
  bool _isExpanded = true;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd'); // Date format
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  final FocusNode fromDateNode = FocusNode();
  final FocusNode toDateNode = FocusNode();

  final DateTime firstDate = DateTime(2021, 1, 1);
  final DateTime lastDate = DateTime(2026, 1, 1);

  @override
  void initState() {
    super.initState();
    context.read<ReportFilterCubit>().getReports();
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = _dateFormat.format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InfoWidget(
      builder: (context, info) {
        return SafeArea(
          child: BlocConsumer<ReportFilterCubit, ReportFilterState>(
            listener: (context, state) {
              if (state is ReportFilterloaded) {
                _isExpanded = false;
              }
            },
            builder: (context, state) {
              var reports = context.watch<ReportFilterCubit>().reports ?? [];
              var cubit = context.read<ReportFilterCubit>();
              return Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    HeaderWidget(
                      isAdmin: false,
                      isUser: false,
                      extraButtons: [],
                      isBackButtonVisible: true,
                      info: info,
                      onBackPressed: () => context.pop(),
                      titleImageAsset: 'assets/images/Title_img.png',
                    ),
                    Container(
                      alignment: AlignmentDirectional.centerStart,
                      padding: EdgeInsetsDirectional.only(
                        start: info.screenWidth * 0.05,
                      ),
                      child: Text(
                        'Post Reports',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: info.screenWidth * 0.05,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(
                        top: info.screenHeight * 0.01,
                      ),
                      padding: EdgeInsets.all(info.screenWidth * 0.021),
                      width: info.screenWidth * 0.87,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0, 2),
                            blurRadius: info.screenWidth * 0.02,
                            spreadRadius: info.screenWidth * 0.015,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          info.screenWidth * 0.08,
                        ),
                        border: Border.all(
                          color: ColorsManager.primaryColor,
                          width: info.screenWidth * 0.0015,
                        ),
                      ),

                      child: ExpansionPanelList(
                        elevation: 0,
                        expandedHeaderPadding: EdgeInsets.all(
                          info.screenWidth * 0.01,
                        ),
                        expandIconColor: ColorsManager.primaryColor,
                        expansionCallback: (panelIndex, isExpanded) {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        children: [
                          ExpansionPanel(
                            backgroundColor: Colors.white,
                            isExpanded: _isExpanded,
                            canTapOnHeader: true,

                            headerBuilder: (context, isExpanded) {
                              return ListTile(
                                title: Text(
                                  'Filter Options',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                            body: Container(
                              padding: EdgeInsetsDirectional.only(
                                start: info.screenWidth * 0.05,
                                end: info.screenWidth * 0.04,
                                top: info.screenHeight * 0.01,
                                bottom: info.screenHeight * 0.01,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      DropMenuWidget(
                                        info: info,
                                        onChange: (value) {
                                          setState(
                                            () => cubit.statusId = value,
                                          );
                                        },
                                        value: cubit.statusId,
                                        itemsList: [
                                          DropdownMenuItem(
                                            value: 1,
                                            child: Text('Pending'),
                                          ),
                                          DropdownMenuItem(
                                            value: 2,
                                            child: Text('Approved'),
                                          ),
                                          DropdownMenuItem(
                                            value: 3,
                                            child: Text('Cascaded Approval'),
                                          ),
                                          DropdownMenuItem(
                                            value: 4,
                                            child: Text('Rejected'),
                                          ),
                                        ],
                                        hintText: 'Status',
                                      ),

                                      DropMenuWidget(
                                        info: info,
                                        onChange: (value) {
                                          setState(
                                            () => cubit.categoryId = value,
                                          );
                                        },
                                        value: cubit.categoryId,
                                        itemsList: [
                                          DropdownMenuItem(
                                            value: 1,
                                            child: Text('Spam'),
                                          ),
                                          DropdownMenuItem(
                                            value: 2,
                                            child: Text('Copyright Violation'),
                                          ),
                                          DropdownMenuItem(
                                            value: 3,
                                            child: Text('False Information'),
                                          ),
                                        ],
                                        hintText: 'Category',
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: info.screenHeight * 0.01),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // SizedBox(
                                      //   width: info.screenWidth * 0.3,
                                      //   child: TextField(
                                      //     controller: fromDateController,
                                      //     decoration: InputDecoration(
                                      //       labelText: 'From Date',
                                      //       suffixIcon: IconButton(
                                      //         icon: Icon(Icons.calendar_today),
                                      //         onPressed: () => _selectDate(context, fromDateController),
                                      //       ),
                                      //     ),
                                      //     readOnly: true,
                                      //   ),
                                      // ),
                                      Expanded(
                                        child: FormTextInput(
                                          controller: fromDateController,
                                          label: 'From Date',
                                          hintText: 'From Date',
                                          screenWidth: info.screenWidth,
                                          screenHeight: info.screenHeight,
                                          focusNode: fromDateNode,
                                          canRequestFucos: false,
                                          onTap:
                                              () => _selectDate(
                                                context,
                                                fromDateController,
                                              ),
                                          validator: (value) {
                                            return validateDateRange(
                                              fromDateController,
                                              toDateController,
                                            );
                                          },
                                        ),
                                      ),

                                      SizedBox(width: info.screenWidth * 0.02),

                                      Expanded(
                                        child: FormTextInput(
                                          controller: toDateController,
                                          label: 'To Date',
                                          hintText: 'To Date',
                                          screenWidth: info.screenWidth,
                                          screenHeight: info.screenHeight,
                                          focusNode: toDateNode,
                                          canRequestFucos: false,
                                          onTap:
                                              () => _selectDate(
                                                context,
                                                toDateController,
                                              ),
                                          validator: (value) {
                                            return validateDateRange(
                                              fromDateController,
                                              toDateController,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: info.screenHeight * 0.01),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      DropMenuWidget(
                                        info: info,
                                        onChange: (value) {
                                          setState(
                                            () =>
                                                cubit.orderBy =
                                                    value.toString(),
                                          );
                                        },
                                        value: cubit.orderBy,
                                        itemsList: [
                                          DropdownMenuItem(
                                            value: 'REPORT_CATEGORY',
                                            child: Text('Report Category'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'REPORT_STATUS',
                                            child: Text('Report Status'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'CREATION_DATE',
                                            child: Text('Creation Date'),
                                          ),
                                        ],
                                        hintText: 'Order By',
                                      ),

                                      DropMenuWidget(
                                        info: info,
                                        onChange: (value) {
                                          setState(
                                            () =>
                                                cubit.orderDir =
                                                    value.toString(),
                                          );
                                        },
                                        value: cubit.orderDir,
                                        itemsList: [
                                          DropdownMenuItem(
                                            value: 'ASC',
                                            child: Text('Ascending'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'DESC',
                                            child: Text('Descending'),
                                          ),
                                        ],
                                        hintText: 'Order Direction',
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: info.screenHeight * 0.01),

                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          ColorsManager.primaryColor,
                                    ),
                                    onPressed: () {
                                      cubit.applyFilter(
                                        fromDateController.text,
                                        toDateController.text,
                                      );
                                    },
                                    child: Text(
                                      'Apply Filter',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: info.screenHeight * 0.01),
                    Expanded(
                      child:
                          reports.isEmpty
                              ? Center(child: Text('No reports available'))
                              : ListView.builder(
                                itemCount: reports.length,
                                padding: EdgeInsetsDirectional.only(
                                  top: info.screenHeight * 0.01,
                                  start: info.screenWidth * 0.02,
                                  end: info.screenWidth * 0.02,
                                ),
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsetsDirectional.only(
                                      top: info.screenHeight * 0.025,
                                    ),
                                    child: MainReportCard(
                                      deviceInfo: info,
                                      postTitle: reports[index].postTitle,
                                      reportedBy: reports[index].reportedBy,
                                      postId: reports[index].postId,
                                      reportDate: reports[index].reportedOn,
                                      reportCategory: reports[index].category,
                                      reportStatus: reports[index].status,
                                      reportId: reports[index].reportId,
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

Widget DropMenuWidget({
  required DeviceInfo info,
  required Function(dynamic)? onChange,
  required dynamic value,
  required List<DropdownMenuItem<dynamic>> itemsList,
  required String hintText,
}) {
  return Container(
    width: info.screenWidth * 0.35,
    padding: EdgeInsets.symmetric(horizontal: info.screenWidth * 0.02),
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: ColorsManager.lightGreyColor,
      border: Border.all(color: ColorsManager.blackColor, width: 0.3),
      borderRadius: BorderRadius.circular(info.screenWidth * 0.02),
    ),
    child: DropdownButton<dynamic>(
      value: value,
      isExpanded: true,
      hint: Text(hintText, style: TextStyles.inter16RegularBlack),
      style: TextStyles.inter16RegularBlack,
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(info.screenWidth * 0.04),

      onChanged: onChange,
      items: itemsList,
      underline: Container(),
    ),
  );
}
