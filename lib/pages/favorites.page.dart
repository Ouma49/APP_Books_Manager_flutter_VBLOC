import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/book.dart';
import '../blocs/book_bloc/book_bloc.dart';
import '../blocs/book_bloc/book_event.dart';
import '../blocs/book_bloc/book_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Books')),
      body: BlocBuilder<BookBloc, BookState>(
        builder: (context, state) {
          if (state is BookLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is BooksLoaded) {
            if (state.books.isEmpty) {
              return const Center(child: Text('No favorite books yet.'));
            }
            return ListView.builder(
              itemCount: state.books.length,
              itemBuilder: (context, index) {
                final book = state.books[index];
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
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<BookBloc>().add(RemoveBook(book.id));
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No favorite books yet.'));
        },
      ),
    );
  }
}
