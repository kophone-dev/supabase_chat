import 'package:flutter/material.dart';
import 'package:supabase_chat/constants/strings.dart';
import 'package:supabase_chat/pages/chat_page.dart';
import 'package:supabase_chat/pages/log_in_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SUPERBASE_URL,
    anonKey: SUPERBASE_ANON_KEY,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    return MaterialApp(
      home: session == null ? const LogInPage() : const ChatPage(),
    );
  }
}
