import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart' hide HttpMethod;

Future<Response> onRequest(RequestContext context, String idOrName) async {
  final supabase = context.read<SupabaseClient>();
  final isId = int.tryParse(idOrName) != null;

  try {
    if (context.request.method == HttpMethod.put) {
      final body = await context.request.json() as Map<String, dynamic>;
      
      var query = supabase.from('produtos').update({
        'nome': body['nome'],
        'descricao': body['descricao'],
        'preco': body['preco'],
        'imagem': body['imagem'],
        'categoria': body['categoria'],
      });

      final response = isId
          ? await query.eq('id', int.parse(idOrName)).select()
          : await query.eq('nome', idOrName).select();

      return Response.json(body: {'message': 'Produto atualizado com sucesso', 'data': response});
    }

    if (context.request.method == HttpMethod.delete) {
      var query = supabase.from('produtos').delete();

      final response = isId
          ? await query.eq('id', int.parse(idOrName)).select()
          : await query.eq('nome', idOrName).select();

      return Response.json(body: {'message': 'Produto deletado com sucesso', 'data': response});
    }

    return Response(statusCode: HttpStatus.methodNotAllowed);
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': e.toString()},
    );
  }
}