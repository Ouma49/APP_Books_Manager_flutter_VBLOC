import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/book.dart';

class ApiService {
  static const String _baseUrl = 'https://www.googleapis.com/books/v1/volumes';

  Future<List<Book>> searchBooks(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl?q=$query'));

    if (response.statusCode == 200) {
      List<Book> books = [];
      final data = json.decode(response.body);
      if (data['items'] != null) {
        data['items'].forEach((item) {
          // Basic check for necessary info before creating Book object
          if (item['id'] != null &&
              item['volumeInfo'] != null &&
              item['volumeInfo']['title'] != null &&
              item['volumeInfo']['authors'] != null &&
              item['volumeInfo']['imageLinks'] != null &&
              item['volumeInfo']['imageLinks']['thumbnail'] != null) {
            books.add(Book.fromJson(item));
          }
        });
      }
      return books;
    } else {
      throw Exception('Failed to load books');
    }
  }
}
