import 'dart:io';
import 'dart:convert';

void main() async {
  // Configurar CORS headers
  HttpServer.bind(InternetAddress.anyIPv4, 5000).then((server) {
    print('🚀 Servidor Dart iniciado en http://localhost:5000');
    print('📱 Aplicación Flutter del taller disponible');
    
    server.listen((request) async {
      // Configurar headers CORS para permitir todos los orígenes
      request.response.headers.set('Access-Control-Allow-Origin', '*');
      request.response.headers.set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
      request.response.headers.set('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
      
      if (request.method == 'OPTIONS') {
        request.response.statusCode = HttpStatus.ok;
        request.response.close();
        return;
      }
      
      String path = request.uri.path;
      print('📂 Solicitando: $path');
      
      try {
        if (path == '/' || path == '/index.html') {
          await serveFile(request, 'web/index.html', 'text/html');
        } else if (path == '/lib/main.dart') {
          await serveFile(request, 'lib/main.dart', 'application/dart');
        } else if (path.endsWith('.dart')) {
          String filePath = path.startsWith('/') ? path.substring(1) : path;
          // Restricción de seguridad - solo archivos dentro de lib/
          if (filePath.startsWith('lib/') && !filePath.contains('..')) {
            await serveFile(request, filePath, 'application/dart');
          } else {
            request.response.statusCode = HttpStatus.forbidden;
            request.response.write('Acceso denegado');
            request.response.close();
          }
        } else if (path.endsWith('.js') || path.endsWith('.js.map') || path.endsWith('.deps')) {
          String filePath = path.startsWith('/') ? path.substring(1) : path;
          // Mapear archivos JavaScript desde la raíz a web/
          if (!filePath.contains('..')) {
            String webPath = filePath.startsWith('web/') ? filePath : 'web/$filePath';
            await serveFile(request, webPath, 'application/javascript');
          } else {
            request.response.statusCode = HttpStatus.forbidden;
            request.response.write('Acceso denegado');
            request.response.close();
          }
        } else {
          // Servir aplicación principal para cualquier ruta no encontrada
          await serveFile(request, 'web/index.html', 'text/html');
        }
      } catch (e) {
        print('❌ Error sirviendo $path: $e');
        request.response.statusCode = HttpStatus.notFound;
        request.response.write('404 - No encontrado');
        request.response.close();
      }
    });
  }).catchError((e) {
    print('❌ Error iniciando servidor: $e');
  });
}

Future<void> serveFile(HttpRequest request, String filePath, String contentType) async {
  try {
    final file = File(filePath);
    if (await file.exists()) {
      request.response.headers.contentType = ContentType.parse(contentType);
      await request.response.addStream(file.openRead());
      request.response.close();
      print('✅ Servido: $filePath');
    } else {
      print('⚠️  Archivo no encontrado: $filePath');
      request.response.statusCode = HttpStatus.notFound;
      request.response.write('Archivo no encontrado: $filePath');
      request.response.close();
    }
  } catch (e) {
    print('❌ Error leyendo archivo $filePath: $e');
    request.response.statusCode = HttpStatus.internalServerError;
    request.response.write('Error interno del servidor');
    request.response.close();
  }
}