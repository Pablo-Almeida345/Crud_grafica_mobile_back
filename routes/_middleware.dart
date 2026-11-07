import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart';

Handler middleware(Handler handler) {
  return (context) async {
    final supabaseUrl = Platform.environment['SUPABASE_URL'] ?? 'https://fshgacospypbgxzzpnxt.supabase.co';
    
    // Cole a sua Secret key aqui (começa com sb_secret_)
    final supabaseKey = Platform.environment['SUPABASE_ANON_KEY'] ?? 'sb_publishable_DkO4BfBFcSI3bBeUhojB1Q_pjFPdlMj';

    final supabase = SupabaseClient(supabaseUrl, supabaseKey);

    final newContext = context.provide<SupabaseClient>(() => supabase);

    return await handler(newContext);
  };
}