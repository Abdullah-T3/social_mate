import 'package:jwt_decoder/jwt_decoder.dart';

import '../model/jwtModel.dart';

class JwtTokenDecodeRepositoryImp {
  JwtModel decodeToken(String token) {
    try {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return JwtModel.fromJson(decodedToken);
    } catch (e) {
      throw Exception('Failed to decode JWT token');
    }
  }
}
