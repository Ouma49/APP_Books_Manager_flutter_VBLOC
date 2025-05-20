import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../models/book.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<Book>> _favoriteBooks;

  @override
  void initState() {
    super.initState();
    _favoriteBooks = DbService().getItems();
  }

  void _deleteBook(String id) async {
    await DbService().deleteItem(id);
    setState(() {
      _favoriteBooks =
          DbService().getItems(); // Refresh the list after deletion
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite Books')),
      body: FutureBuilder<List<Book>>(
        future: _favoriteBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No favorite books yet.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final book = snapshot.data![index];
                return ListTile(
                  leading: Image.network(
                    book.imageUrl,
                    width: 50,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  title: Text(book.title),
                  subtitle: Text(book.author),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteBook(book.id),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
