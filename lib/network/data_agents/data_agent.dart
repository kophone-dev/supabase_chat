import 'dart:io';

import 'package:supabase_chat/model/vos/messag_vo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DataAgent {
  Future<AuthResponse?> register({required String email, required String password});
  Future<AuthResponse?> logIn({required String email, required String password});
  Future<void> sendMessage({
    required String message,
    required String userId,
    required String userEmail,
    String? fileUrl,
  });
  Stream<List<MessageVo>?> listenNewMessage();
  Future<List<MessageVo>?> getMessage();
  Future<String> uploadFile(
    File file,
  );
}
