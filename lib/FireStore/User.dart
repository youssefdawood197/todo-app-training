class User {
  static const String collection = "users"; // Lowercase for collection name

  String? id;
  String? fullName; // Changed to camelCase for consistency
  String? email;

  User({this.id, this.fullName, this.email});

  User.fromFirestore(Map<String, dynamic>? data) {
    id = data?["id"];
    fullName = data?["FullName"];
    email = data?["email"];
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "FullName": fullName, // Ensure keys match your Firestore document
      "email": email,
    };
  }
}