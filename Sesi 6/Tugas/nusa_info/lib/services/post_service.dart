import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class ApiException implements Exception {
  final String message;

  /// true kalau penyebabnya internet mati / tidak ada koneksi
  final bool isOffline;

  const ApiException(this.message, {this.isOffline = false});

  @override
  String toString() => message;
}

/// Semua request HTTP ada di sini.
/// Urutan tiap method: 1) buat alamat, 2) kirim request,
/// 3) cek status code, 4) ubah JSON menjadi objek.
class PostService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration _timeout = Duration(seconds: 15);

  // GET /posts
  Future<List<Post>> fetchPosts() async {
    // 1. buat alamat
    final uri = Uri.parse('$_baseUrl/posts');
    try {
      // 2. kirim request
      final response = await http.get(uri).timeout(_timeout);
      // 3. cek status code
      if (response.statusCode != 200) {
        throw ApiException('Gagal memuat pengumuman (${response.statusCode})');
      }
      // 4. ubah JSON menjadi objek
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((item) => Post.fromJson(item as Map<String, dynamic>))
          .toList();
    } on SocketException {
      throw const ApiException('Tidak ada koneksi internet', isOffline: true);
    } on http.ClientException {
      throw const ApiException('Tidak ada koneksi internet', isOffline: true);
    } on TimeoutException {
      throw const ApiException('Koneksi timeout, coba lagi');
    }
  }

  // GET /posts/{id}/comments
  Future<List<Comment>> fetchComments(int postId) async {
    final uri = Uri.parse('$_baseUrl/posts/$postId/comments');
    try {
      final response = await http.get(uri).timeout(_timeout);
      if (response.statusCode != 200) {
        throw ApiException('Gagal memuat komentar (${response.statusCode})');
      }
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((item) => Comment.fromJson(item as Map<String, dynamic>))
          .toList();
    } on SocketException {
      throw const ApiException('Tidak ada koneksi internet', isOffline: true);
    } on http.ClientException {
      throw const ApiException('Tidak ada koneksi internet', isOffline: true);
    } on TimeoutException {
      throw const ApiException('Koneksi timeout, coba lagi');
    }
  }

  // POST /posts
  Future<Post> createPost(Post post) async {
    final uri = Uri.parse('$_baseUrl/posts');
    try {
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode(post.toJson()),
          )
          .timeout(_timeout);
      // jsonplaceholder membalas 201 Created
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw ApiException('Gagal membuat pengumuman (${response.statusCode})');
      }
      return Post.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } on SocketException {
      throw const ApiException('Tidak ada koneksi internet', isOffline: true);
    } on http.ClientException {
      throw const ApiException('Tidak ada koneksi internet', isOffline: true);
    } on TimeoutException {
      throw const ApiException('Koneksi timeout, coba lagi');
    }
  }
}
