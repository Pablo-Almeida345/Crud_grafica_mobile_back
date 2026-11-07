import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:supabase/supabase.dart' hide HttpMethod;

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final supabase = context.read<SupabaseClient>();
    
    final pedidos = await supabase.from('pedidos').select();

    final totalPedidos = pedidos.length;
    final Map<String, int> statusCount = {};

    for (var pedido in pedidos) {
      final status = pedido['status']?.toString() ?? 'indefinido';
      statusCount[status] = (statusCount[status] ?? 0) + 1;
    }

    return Response.json(body: {
      'total_pedidos': totalPedidos,
      'analise_status': statusCount,
      'pedidos': pedidos,
    });
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': e.toString()},
    );
  }
}