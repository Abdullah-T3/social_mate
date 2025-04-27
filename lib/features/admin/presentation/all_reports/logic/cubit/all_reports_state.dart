part of 'all_reports_cubit.dart';

abstract class AllReportsState {
}

class AllReportsInitial extends AllReportsState {}

class AllReportsLoading extends AllReportsState {}
class AllReportsLoadingMore extends AllReportsState {
  final List<MainReportEntity> allReports;
  AllReportsLoadingMore(this.allReports);
}
class AllReportsLoaded extends AllReportsState {
  final List<MainReportEntity> allReports;
  final bool hasMore;
  AllReportsLoaded(this.allReports, this.hasMore);

  AllReportsLoaded copyWith({
    List<MainReportEntity>? allReports,
    bool? hasMore,
  }) {
    return AllReportsLoaded(
      allReports ?? this.allReports,
      hasMore ?? this.hasMore,
    );
  }
}

class AllReportsEmpty extends AllReportsState {
  final List<MainReportEntity> allReports;
  AllReportsEmpty(this.allReports);
}

class AllReportsError extends AllReportsState {
  final String errorMessage;
  AllReportsError(this.errorMessage);
}

class AllReportsConnectionError extends AllReportsState {}
class AllReportsStatusCodeError extends AllReportsState {}