part of 'report_filter_cubit.dart';

@immutable
sealed class ReportFilterState {}

final class ReportFilterInitial extends ReportFilterState {}

final class ReportFilterloading extends ReportFilterState {}
final class ReportFilterloaded extends ReportFilterState {}
final class ReportFilterError extends ReportFilterState {
  final String message;
  ReportFilterError(this.message);
}

