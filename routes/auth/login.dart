import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart' hide HttpMethod;

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final identificador = body['identificador']; // Nome, CPF ou Email
    final senha = body['senha'];

    if (identificador == null || senha == null) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': 'Informe o identificador (nome, cpf ou email) e a senha.'},
      );
    }

    final supabase = context.read<SupabaseClient>();

    final response = await supabase
        .from('usuarios')
        .select()
        .or('email.eq.$identificador,cpf.eq.$identificador,nome.eq.$identificador')
        .eq('senha', senha)
        .maybeSingle();

    if (response == null) {
      return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {'error': 'Credenciais inválidas.'},
      );
    }

    return Response.json(body: {
      'message': 'Login realizado com sucesso!',
      'usuario': response,
    });
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': e.toString()},
    );
  }
}