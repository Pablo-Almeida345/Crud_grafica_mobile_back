import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart' hide HttpMethod;

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final nome = body['nome'];
    final cpf = body['cpf'];
    final email = body['email'];
    final senha = body['senha'];

    if (nome == null || cpf == null || email == null || senha == null) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': 'Campos obrigatórios faltando: nome, cpf, email, senha.'},
      );
    }

    final supabase = context.read<SupabaseClient>();

    final response = await supabase.from('usuarios').insert({
      'nome': nome,
      'cpf': cpf,
      'email': email,
      'senha': senha,
    }).select();

    return Response.json(statusCode: HttpStatus.created, body: response);
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': e.toString()},
    );
  }
}