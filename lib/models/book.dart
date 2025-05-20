class Book {
  final String id;
  final String title;
  final String author;
  final String imageUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['volumeInfo']['title'] as String,
      author: (json['volumeInfo']['authors'] as List).join(', '),
      imageUrl: json['volumeInfo']['imageLinks']['thumbnail'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'author': author, 'imageUrl': imageUrl};
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as String,
      title: map['title'] as String,
      author: map['author'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }
}
