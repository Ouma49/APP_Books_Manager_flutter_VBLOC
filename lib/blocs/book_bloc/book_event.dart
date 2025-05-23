import 'package:equatable/equatable.dart';
import 'package:books_manager/models/book.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object> get props => [];
}

class LoadBooks extends BookEvent {}

class AddBook extends BookEvent {
  final Book book;

  const AddBook(this.book);

  @override
  List<Object> get props => [book];
}

class RemoveBook extends BookEvent {
  final String bookId;

  const RemoveBook(this.bookId);

  @override
  List<Object> get props => [bookId];
} 