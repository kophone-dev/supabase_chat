// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messag_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageVo _$MessageVoFromJson(Map<String, dynamic> json) => MessageVo(
      id: (json['id'] as num?)?.toInt(),
      insertedAt: json['inserted_at'] as String?,
      message: json['message'] as String?,
      userId: json['user_id'] as String?,
      channelId: (json['channel_id'] as num?)?.toInt(),
      userEmail: json['user_email'] as String?,
      filePath: json['file_path'] as String?,
      isUserMsg: json['isUserMsg'] as bool?,
    );

Map<String, dynamic> _$MessageVoToJson(MessageVo instance) => <String, dynamic>{
      'id': instance.id,
      'inserted_at': instance.insertedAt,
      'message': instance.message,
      'user_id': instance.userId,
      'channel_id': instance.channelId,
      'user_email': instance.userEmail,
      'file_path': instance.filePath,
      'isUserMsg': instance.isUserMsg,
    };
