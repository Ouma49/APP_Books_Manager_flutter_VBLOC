import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import '../services/db_service.dart';
import 'favorites.page.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Book>> _searchResults;
  final DbService _dbService = DbService();

  @override
  void initState() {
    super.initState();
    _searchResults = Future.value([]); // Initialize with an empty list
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchBooks() {
    setState(() {
      _searchResults = ApiService().searchBooks(_searchController.text);
    });
  }

  void _toggleFavorite(Book book) async {
    final isFavorite = await _dbService.isFavorite(book.id);
    if (isFavorite) {
      await _dbService.deleteItem(book.id);
    } else {
      await _dbService.insertItem(book);
    }
    // No need to refresh search results, just the icon should change
    setState(() {}); // Trigger a rebuild to update the icon
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Finder'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by keyword',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchBooks,
                ),
              ),
              onSubmitted: (_) => _searchBooks(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: _searchResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('Enter a keyword to search for books.'),
                  );
                } else {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.6, // Adjust aspect ratio as needed
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final book = snapshot.data![index];
                      return FutureBuilder<bool>(
                        future: _dbService.isFavorite(book.id),
                        builder: (context, favoriteSnapshot) {
                          final isFavorite = favoriteSnapshot.data ?? false;
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      book.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Icon(Icons.book),
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    book.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    book.author,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(
                                      icon: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFavorite ? Colors.red : null,
                                      ),
                                      onPressed: () => _toggleFavorite(book),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

extension on DbService {
  Future<bool> isFavorite(String id) async {
    final db = await database;
    final count = await db.rawQuery(
      'SELECT COUNT(*) FROM favorites WHERE id = ?',
      [id],
    );
    int? result = Sqflite.firstIntValue(count);
    return result != null && result > 0;
  }
}
