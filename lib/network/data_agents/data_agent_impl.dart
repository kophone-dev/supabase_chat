import 'dart:io';

import 'package:supabase_chat/model/vos/messag_vo.dart';
import 'package:supabase_chat/network/api.dart';
import 'package:supabase_chat/network/data_agents/data_agent.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DataAgentImpl implements DataAgent {
  static final DataAgentImpl _singleton = DataAgentImpl._internal();
  factory DataAgentImpl() {
    return _singleton;
  }
  final SupabaseApi _api = SupabaseApi();

  DataAgentImpl._internal();

  @override
  Future<AuthResponse?> logIn({required String email, required String password}) {
    return _api.logIn(email: email, password: password);
  }

  @override
  Future<AuthResponse?> register({required String email, required String password}) {
    return _api.register(email: email, password: password);
  }

  @override
  Future<void> sendMessage({
    required String message,
    required String userId,
    required String userEmail,
    String? fileUrl,
  }) {
    return _api.sendMessage(message: message, userId: userId, userEmail: userEmail, fileUrl: fileUrl);
  }

  @override
  Future<List<MessageVo>?> getMessage() {
    return _api.getMessage().then(
      (value) {
        return value
            ?.map(
              (e) => MessageVo.fromJson(e),
            )
            .toList();
      },
    );
  }

  @override
  Stream<List<MessageVo>?> listenNewMessage() {
    return _api.listenNewMessage().map(
      (value) {
        return value
            ?.map(
              (e) => MessageVo.fromJson(e),
            )
            .toList();
      },
    );
  }

  @override
  Future<String> uploadFile(File file) {
    return _api.uploadFile(file);
  }
}
