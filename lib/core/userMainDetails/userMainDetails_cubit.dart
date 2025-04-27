import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/userMainDetails/jwt_token_decode/data/repository/jwt_token_decode_repository_imp.dart';

import '../di/di.dart';
import '../helper/SharedPref/SharedPrefKeys.dart';
import '../helper/SharedPref/sharedPrefHelper.dart';
import 'jwt_token_decode/data/model/jwtModel.dart';
import 'userMainDetails_state.dart';

// ignore: camel_case_types
class userMainDetailsCubit extends Cubit<userMainDetailsState> {
  final JwtTokenDecodeRepositoryImp _repository;
  final SharedPrefHelper _sharedPrefHelper = getIt<SharedPrefHelper>();

  userMainDetailsCubit(this._repository)
    : super(userMainDetailsState(token: null));

  Future<void> decodeAndAssignToken(String token) async {
    try {
      final JwtModel jwt = _repository.decodeToken(token);

      bool isAdmin = jwt.rolesIds!.contains(1);
      bool isMember = jwt.rolesIds!.contains(2);

      emit(
        state.copyWith(
          token: token,
          userId: jwt.userId,
          iat: jwt.iat,
          exp: jwt.exp,
          rolesIds: jwt.rolesIds,
          sub: jwt.sub,
          isAdmin: isAdmin,
          isMember: isMember,
        ),
      );
    } catch (e) {
      emit(userMainDetailsErrorState(message: e.toString()));
    }
  }

  Future<void> getToken() async {
    try {
      final token = _sharedPrefHelper.getString(SharedPrefKeys.tokenKey);
      if (token != null) {
        decodeAndAssignToken(token);
      }
    } catch (e) {
      emit(userMainDetailsErrorState(message: e.toString()));
    }
  }

  Future<void> logOut() async {
    try {
      await _sharedPrefHelper.remove(SharedPrefKeys.tokenKey);
      emit(userMainDetailsState(token: null));
    } catch (e) {
      emit(userMainDetailsErrorState(message: e.toString()));
    }
  }
}
