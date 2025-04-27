import 'package:bloc/bloc.dart';

import '../../../../../../core/di/di.dart' show getIt;
import '../../../../../../core/helper/Connectivity/connectivity_helper.dart'
    show ConnectivityHelper;
import '../../../../../../core/userMainDetails/userMainDetails_cubit.dart'
    show userMainDetailsCubit;
import '../../../../domain/entities/main_report_entity.dart';
import '../../../../domain/repositories/main_report_repo.dart';

part 'all_reports_state.dart';

class AllReportsCubit extends Cubit<AllReportsState> {
  final MainReportRepo mainReportRepo;
  int _pageOffset = 0;
  final int _pageSize = 5;
  bool _hasMore = true;

  AllReportsCubit({required this.mainReportRepo}) : super(AllReportsInitial());

  Future<void> getAllReports(
    Map<String, dynamic> queryParams, {
    required String token,
  }) async {
    bool isConnected = await ConnectivityHelper.isConnected();
    if (!isConnected) {
      if (!isClosed) emit(AllReportsConnectionError());
      return;
    } else {
      // Reset the state
      _pageOffset = 0;
      _hasMore = true;
      if (!isClosed) emit(AllReportsLoading());

      try {
        final result = await mainReportRepo.getAllReports({
          ...queryParams,
          'pageOffset': _pageOffset,
          'pageSize': _pageSize,
        }, token: token);

        final statusCode = result['statusCode'] as int;
        if (statusCode != 200) {
          if (!isClosed) emit(AllReportsStatusCodeError());
          return;
        }
        final reports = result['reports'] as List<MainReportEntity>;

        if (reports.isEmpty) {
          if (!isClosed) emit(AllReportsEmpty(reports));
        } else {
          _hasMore = reports.length == _pageSize;
          if (!isClosed) {
            emit(AllReportsLoaded(reports, _hasMore));
          }
        }
      } catch (e) {
        if (!isClosed) emit(AllReportsError(e.toString()));
      }
    }
  }

  Future<void> loadMoreReports(
    Map<String, dynamic> queryParams, {
    required String token,
  }) async {
    if (state is! AllReportsLoaded || !_hasMore) return;

    final currentState = state as AllReportsLoaded;
    if (!isClosed) {
      emit(
        currentState.copyWith(hasMore: false),
      ); // Disable loading more temporarily
    }

    try {
      _pageOffset += _pageSize;
      final result = await mainReportRepo.getAllReports({
        ...queryParams,
        'pageOffset': _pageOffset,
        'pageSize': _pageSize,
      }, token: token);

      final statusCode = result['statusCode'] as int;
      if (statusCode != 200) {
        if (!isClosed) emit(AllReportsStatusCodeError());
        return;
      }

      final newReports = result['reports'] as List<MainReportEntity>;

      // Update _hasMore based on the length of new reports
      _hasMore = newReports.length == _pageSize;
      final updatedReports = [...currentState.allReports, ...newReports];
      if (!isClosed) {
        emit(
          currentState.copyWith(allReports: updatedReports, hasMore: _hasMore),
        );
      }
    } catch (e) {
      if (!isClosed) emit(AllReportsError(e.toString()));
    }
  }

  void clearState() {
    emit(AllReportsInitial());
  }

  Future<void> onRefresh() async {
    _pageOffset = 0;
    _hasMore = true;
    emit(AllReportsInitial());
    await getAllReports({
      'statusId': 1,
    }, token: getIt<userMainDetailsCubit>().state.token!);
    ();
  }
}
