import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart' hide HttpMethod;

Future<Response> onRequest(RequestContext context) async {
  final supabase = context.read<SupabaseClient>();

  try {
    if (context.request.method == HttpMethod.get) {
      // Tabela alterada de 'produtos' para 'produto'
      final produtos = await supabase.from('produto').select();
      return Response.json(body: produtos);
    } 
    
    if (context.request.method == HttpMethod.post) {
      final body = await context.request.json() as Map<String, dynamic>;
      
      // Tabela alterada de 'produtos' para 'produto'
      final response = await supabase.from('produto').insert({
        'nome': body['nome'],
        'descricao': body['descricao'],
        'preco': body['preco'],
        'imagem': body['imagem'],
        'categoria': body['categoria'],
      }).select();

      return Response.json(statusCode: HttpStatus.created, body: response);
    }

    return Response(statusCode: HttpStatus.methodNotAllowed);
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': e.toString()},
    );
  }
}