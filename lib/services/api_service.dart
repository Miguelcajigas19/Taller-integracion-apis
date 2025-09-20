import 'dart:html';
import 'dart:convert';
import '../models/post.dart';
import '../models/country.dart';

class ApiService {
  static const String jsonPlaceholderBase = 'https://jsonplaceholder.typicode.com';
  static const String countriesGraphQLEndpoint = 'https://countries.trevorblades.com/';

  // Métodos para API REST JSONPlaceholder
  Future<List<Post>> getPosts() async {
    try {
      final response = await HttpRequest.request(
        '$jsonPlaceholderBase/posts',
        method: 'GET',
      );
      
      if (response.status == 200) {
        final List<dynamic> jsonList = jsonDecode(response.responseText!);
        final allPosts = jsonList.map((json) => Post.fromJson(json)).toList();
        
        // Filtrar posts: encontrar el post específico y mantener solo los 4 primeros anteriores
        int cutoffIndex = -1;
        
        for (int i = 0; i < allPosts.length; i++) {
          if (allPosts[i].title.contains('sunt aut facere repellat provident')) {
            cutoffIndex = i;
            break;
          }
        }
        
        // Si encontramos el post objetivo, tomar máximo 4 posts anteriores (excluyendo el objetivo)
        if (cutoffIndex >= 0) {
          // Tomar los posts anteriores al objetivo, máximo 4
          final postsBeforeTarget = allPosts.take(cutoffIndex).toList();
          return postsBeforeTarget.length > 4 ? postsBeforeTarget.take(4).toList() : postsBeforeTarget;
        } else {
          // Si no encontramos el post objetivo, tomar los primeros 4
          return allPosts.take(4).toList();
        }
      } else {
        throw Exception('Error al obtener posts: ${response.status}');
      }
    } catch (e) {
      throw Exception('Error de conexión al obtener posts: $e');
    }
  }

  Future<Post> createPost(Post post) async {
    try {
      final response = await HttpRequest.request(
        '$jsonPlaceholderBase/posts',
        method: 'POST',
        requestHeaders: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        sendData: jsonEncode({
          'title': post.title,
          'body': post.body,
          'userId': post.userId,
        }),
      );
      
      if (response.status == 200 || response.status == 201) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.responseText!);
        return Post.fromJson(jsonResponse);
      } else {
        throw Exception('Error al crear post: ${response.status}');
      }
    } catch (e) {
      throw Exception('Error de conexión al crear post: $e');
    }
  }

  // Métodos para API GraphQL Countries
  Future<List<Country>> getCountries() async {
    const String query = '''
      query GetCountries {
        countries {
          code
          name
          capital
          emoji
          continent {
            name
          }
        }
      }
    ''';

    try {
      final response = await HttpRequest.request(
        countriesGraphQLEndpoint,
        method: 'POST',
        requestHeaders: {
          'Content-Type': 'application/json',
        },
        sendData: jsonEncode({
          'query': query,
        }),
      );
      
      if (response.status == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.responseText!);
        final List<dynamic> countriesData = jsonResponse['data']['countries'];
        return countriesData.map((json) => Country.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener países: ${response.status}');
      }
    } catch (e) {
      throw Exception('Error de conexión al obtener países: $e');
    }
  }

  Future<Country?> getCountryByCode(String code) async {
    const String query = '''
      query GetCountryByCode(\$code: ID!) {
        country(code: \$code) {
          code
          name
          capital
          emoji
          continent {
            name
          }
        }
      }
    ''';

    try {
      final response = await HttpRequest.request(
        countriesGraphQLEndpoint,
        method: 'POST',
        requestHeaders: {
          'Content-Type': 'application/json',
        },
        sendData: jsonEncode({
          'query': query,
          'variables': {'code': code},
        }),
      );
      
      if (response.status == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.responseText!);
        final countryData = jsonResponse['data']['country'];
        if (countryData != null) {
          return Country.fromJson(countryData);
        }
        return null;
      } else {
        throw Exception('Error al obtener país: ${response.status}');
      }
    } catch (e) {
      throw Exception('Error de conexión al obtener país: $e');
    }
  }
}