import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseApi {
  static final SupabaseApi _singleton = SupabaseApi._internal();
  factory SupabaseApi() {
    return _singleton;
  }

  final supabase = Supabase.instance.client;

  SupabaseApi._internal();

  Future<AuthResponse?> register({required String email, required String password}) async {
    return supabase.auth.signUp(email: email, password: password).then(
      (value) {
        return value;
      },
    );
  }

  Future<AuthResponse?> logIn({required String email, required String password}) async {
    return supabase.auth.signInWithPassword(email: email, password: password).then(
      (value) {
        return value;
      },
    );
  }

  Future<void> sendMessage({
    required String message,
    required String userId,
    required String userEmail,
    String? fileUrl,
  }) {
    return supabase.from('messages').insert({
      'message': message,
      'user_id': userId,
      'channel_id': 1,
      'user_email': userEmail,
      if (fileUrl != null) 'file_path': fileUrl
    });
  }

  Future<String> uploadFile(
    File file,
  ) {
    return supabase.storage.from('msg_file').upload('msg_images/${DateTime.now().millisecondsSinceEpoch.toString()}.png', file);
  }

  Future<List<Map<String, dynamic>>?> getMessage() {
    return supabase.from('messages').select().order('inserted_at');
  }

  Stream<List<Map<String, dynamic>>?> listenNewMessage() {
    return supabase
        .from('messages')
        .stream(primaryKey: [
          'id'
        ])
        .order('inserted_at')
        .map(
          (event) => event,
        );
  }
}
