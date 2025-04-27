import 'package:flutter_bloc/flutter_bloc.dart';

class PostCardCubit extends Cubit<bool> {
  PostCardCubit() : super(false);

  void toggleExpansion() {
    emit(!state);
  }
}
