part of 'report_details_cubit.dart';

sealed class ReportDetailsState extends Equatable {
  const ReportDetailsState();

  @override
  List<Object> get props => [];
}

final class ReportDetailsInitial extends ReportDetailsState {
  
}

final class ReportDetailsLoading extends ReportDetailsState {}

final class ReportDetailsError extends ReportDetailsState {
  final String message;
  const ReportDetailsError({required this.message});
}
final class AddActionToReportLoading extends ReportDetailsState {}
final class AddActionToReportError extends ReportDetailsState {
  final String message;
  const AddActionToReportError({required this.message});
}
final class AddActionToReportSuccess extends ReportDetailsState {
}
final class ReportDetailsLoaded extends ReportDetailsState {
  final DetailedReportModel report;
  final int commentsCount;
  final double avrageRating;

  const ReportDetailsLoaded({
    required this.report,
    required this.commentsCount,
    required this.avrageRating,
  });
}
final class CommentsCountLoaded extends ReportDetailsState {
  final int commentsCount;
  const CommentsCountLoaded({required this.commentsCount});
}
final class CommentsCountRepLoading extends ReportDetailsState {}
final class CommentsCountError extends ReportDetailsState {
  final String message;
  const CommentsCountError({required this.message});
}
final class GetAvrageRatingLoaded extends ReportDetailsState {
  final double avrageRating;    
  const GetAvrageRatingLoaded({required this.avrageRating});
}
final class GetAvrageRatingLoading extends ReportDetailsState {}
final class GetAvrageRatingError extends ReportDetailsState {
  final String message;
  const GetAvrageRatingError({required this.message});
}