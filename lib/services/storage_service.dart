import 'dart:html' as html;
import 'dart:convert';
import '../models/post.dart';

class StorageService {
  static const String _postsKey = 'flutter_app_posts';

  // Simular SharedPreferences usando localStorage del navegador
  Future<void> savePost(Post post) async {
    try {
      final existingPosts = await getStoredPosts();
      existingPosts.removeWhere((p) => p.id == post.id);
      existingPosts.insert(0, post);
      await savePosts(existingPosts);
    } catch (e) {
      print('Error guardando post: $e');
    }
  }

  Future<void> savePosts(List<Post> posts) async {
    try {
      final jsonString = jsonEncode(posts.map((post) => post.toJson()).toList());
      html.window.localStorage[_postsKey] = jsonString;
    } catch (e) {
      print('Error guardando posts: $e');
    }
  }

  Future<List<Post>> getStoredPosts() async {
    try {
      final jsonString = html.window.localStorage[_postsKey];
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((json) => Post.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error cargando posts almacenados: $e');
      return [];
    }
  }

  Future<void> deletePost(int postId) async {
    try {
      final existingPosts = await getStoredPosts();
      existingPosts.removeWhere((post) => post.id == postId);
      await savePosts(existingPosts);
    } catch (e) {
      print('Error eliminando post: $e');
    }
  }

  Future<void> clearAllPosts() async {
    try {
      html.window.localStorage.remove(_postsKey);
    } catch (e) {
      print('Error limpiando posts: $e');
    }
  }

  Future<bool> hasStoredPosts() async {
    try {
      final posts = await getStoredPosts();
      return posts.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}