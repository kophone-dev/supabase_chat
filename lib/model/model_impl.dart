import 'dart:io';

import 'package:supabase_chat/model/model.dart';
import 'package:supabase_chat/model/vos/messag_vo.dart';
import 'package:supabase_chat/network/data_agents/data_agent.dart';
import 'package:supabase_chat/network/data_agents/data_agent_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ModelImpl implements Model {
  static final ModelImpl _singleton = ModelImpl._internal();
  factory ModelImpl() {
    return _singleton;
  }

  ModelImpl._internal();

  final DataAgent _dataAgent = DataAgentImpl();

  @override
  Future<AuthResponse?> logIn({required String email, required String password}) {
    return _dataAgent.logIn(email: email, password: password);
  }

  @override
  Future<AuthResponse?> register({required String email, required String password}) {
    return _dataAgent.register(email: email, password: password);
  }

  @override
  Future<List<MessageVo>?> getMessage() {
    return _dataAgent.getMessage();
  }

  @override
  Future<void> sendMessage({required String message, required String userId, required String userEmail, File? file}) async {
    String? fileUrl;
    if (file != null) {
      fileUrl = await _dataAgent.uploadFile(file);
    }
    return _dataAgent.sendMessage(message: message, userId: userId, userEmail: userEmail, fileUrl: fileUrl);
  }

  @override
  Stream<List<MessageVo>?> listenNewMessage() {
    return _dataAgent.listenNewMessage();
  }
}
