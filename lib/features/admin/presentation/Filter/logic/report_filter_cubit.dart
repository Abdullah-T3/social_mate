import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../core/userMainDetails/userMainDetails_cubit.dart'
    show userMainDetailsCubit;
import '../../../domain/entities/main_report_entity.dart' show MainReportEntity;
import '../../../domain/repositories/reportFilter/reportFilter_repo.dart'
    show reportFilterRepository;

part 'report_filter_state.dart';

class ReportFilterCubit extends Cubit<ReportFilterState> {
  final reportFilterRepository ReportRepo;
  final userMainDetailsCubit userMainDetails;

  ReportFilterCubit({required this.userMainDetails, required this.ReportRepo})
    : super(ReportFilterInitial());

  List<MainReportEntity>? reports;
  int _currentPage = 0;
  bool hasMoreReports = true;
  bool isLoading = false;

  int? statusId;
  int? categoryId;
  String? createdOnFrom;
  String? createdOnTo;
  String? orderBy;
  String? orderDir;
  int pageOffset = 0;
  int pageSize = 10;

  Future<void> getReports({bool reset = false}) async {
    if (!hasMoreReports || isLoading) return;

    if (reset) {
      reports = [];
      _currentPage = 0;
      hasMoreReports = true;
    }
    isLoading = true;
    int total = 0;
    final _queryParams = {
      'statusId': statusId?.toString(),
      'categoryId': categoryId?.toString(),
      'createdOnFrom': createdOnFrom,
      'createdOnTo': createdOnTo,
      'pageOffset': _currentPage.toString(),
      'pageSize': pageSize.toString(),
      'orderBy': orderBy,
      'orderDir': orderDir,
    }..removeWhere((key, value) => value == null); // Remove null values

    try {
      emit(ReportFilterloading());
      final (newReports, total) = await ReportRepo.getReports(
        queryParams: _queryParams,
      );

      // print('comments length ${comments!.length} $_currentPage $commentsCount ${newReports.length}');

      if (newReports.isEmpty) {
        hasMoreReports = false;
        reports ??= [];
      } else {
        reports ??= [];
        reports!.addAll(newReports);

        _currentPage++;
        hasMoreReports = (_currentPage * pageSize) < total;
      }

      emit(ReportFilterloaded());
    } catch (e) {
      emit(ReportFilterError(e.toString()));
    } finally {
      isLoading = false;
    }
  }

  void applyFilter(String fromDate, String toDate) {
    createdOnFrom = fromDate.isNotEmpty ? fromDate : null;
    createdOnTo = toDate.isNotEmpty ? toDate : null;
    pageOffset = 0;
    reports = [];
    hasMoreReports = true;
    getReports(reset: true);
  }
}
