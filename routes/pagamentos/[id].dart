import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart' hide HttpMethod;

Future<Response> onRequest(RequestContext context, String id) async {
  final supabase = context.read<SupabaseClient>();

  if (context.request.method == HttpMethod.patch || context.request.method == HttpMethod.put) {
    try {
      final body = await context.request.json() as Map<String, dynamic>;
      final novoStatus = body['status'];

      if (novoStatus == null) {
        return Response.json(
          statusCode: HttpStatus.badRequest,
          body: {'error': 'O campo "status" é obrigatório para alteração.'},
        );
      }

      final response = await supabase
          .from('pagamento')
          .update({'status': novoStatus})
          .eq('id', id)
          .select();

      return Response.json(body: {
        'message': 'Status do pagamento alterado com sucesso!',
        'data': response,
      });
    } catch (e) {
      return Response.json(
        statusCode: HttpStatus.internalServerError,
        body: {'error': e.toString()},
      );
    }
  }

  return Response(statusCode: HttpStatus.methodNotAllowed);
}