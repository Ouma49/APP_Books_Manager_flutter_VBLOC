import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:books_manager/blocs/book_bloc/book_event.dart';
import 'package:books_manager/blocs/book_bloc/book_state.dart';
import 'package:books_manager/models/book.dart';
import 'package:books_manager/services/database_service.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final DatabaseService _databaseService;

  BookBloc(this._databaseService) : super(BookInitial()) {
    on<LoadBooks>(_onLoadBooks);
    on<AddBook>(_onAddBook);
    on<RemoveBook>(_onRemoveBook);
  }

  Future<void> _onLoadBooks(LoadBooks event, Emitter<BookState> emit) async {
    emit(BookLoading());
    try {
      final books = await _databaseService.getBooks();
      emit(BooksLoaded(books));
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }

  Future<void> _onAddBook(AddBook event, Emitter<BookState> emit) async {
    try {
      await _databaseService.insertBook(event.book);
      final books = await _databaseService.getBooks();
      emit(BooksLoaded(books));
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }

  Future<void> _onRemoveBook(RemoveBook event, Emitter<BookState> emit) async {
    try {
      await _databaseService.deleteBook(event.bookId);
      final books = await _databaseService.getBooks();
      emit(BooksLoaded(books));
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }
} 