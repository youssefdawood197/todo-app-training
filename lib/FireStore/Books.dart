class Books {
  static const String collection = "Books"; // Lowercase for collection name
  String? BookID;
  String? title;
  String? author;
  int? year_pub;
  String? genre;
  Books({this.title, this.author, this.genre, this.year_pub, this.BookID});

  Books.fromFirestore(Map<String, dynamic>? data) {
    BookID = data?["BookID"];
    title = data?["title"];
    author = data?["author"];
    year_pub = data?["year_pub"];
    genre = data?["genre"];
  }

  Map<String, dynamic> toFirestore() {
    return {
      "BookID": BookID,
      "title": title,
      "author": author,
      "year_pub": year_pub,
      "genre": genre,
    };
  }
}
