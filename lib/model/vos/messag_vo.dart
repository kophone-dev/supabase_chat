// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'messag_vo.g.dart';

@JsonSerializable()
class MessageVo {
  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'inserted_at')
  String? insertedAt;
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'user_id')
  String? userId;
  @JsonKey(name: 'channel_id')
  int? channelId;
  @JsonKey(name: 'user_email')
  String? userEmail;
  @JsonKey(name: 'file_path')
  String? filePath;
  bool? isUserMsg;
  MessageVo({
    this.id,
    this.insertedAt,
    this.message,
    this.userId,
    this.channelId,
    this.userEmail,
    this.filePath,
    this.isUserMsg,
  });

  factory MessageVo.fromJson(Map<String, dynamic> json) => _$MessageVoFromJson(json);

  Map<String, dynamic> toJson() => _$MessageVoToJson(this);
}
