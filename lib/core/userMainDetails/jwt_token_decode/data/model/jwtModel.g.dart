// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jwtModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JwtModel _$JwtModelFromJson(Map<String, dynamic> json) => JwtModel(
      rolesIds: (json['ROLES_IDS'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      userId: (json['USER_ID'] as num?)?.toInt(),
      sub: json['sub'] as String?,
      iat: (json['iat'] as num?)?.toInt(),
      exp: (json['exp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$JwtModelToJson(JwtModel instance) => <String, dynamic>{
      'ROLES_IDS': instance.rolesIds,
      'USER_ID': instance.userId,
      'sub': instance.sub,
      'iat': instance.iat,
      'exp': instance.exp,
    };
