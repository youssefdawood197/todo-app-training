class Task{
  static const String collection = "Tasks"; // Lowercase for collection name
String? title = "";
String? description = "";
String? taskId = "";
Task({this.title, this.description, this.taskId});


  Task.fromFirestore(Map<String, dynamic>? data) {
    taskId = data?["taskId"];
    description = data?["description"];
    title = data?["title"];
  }

  Map<String, dynamic> toFirestore() {
    return {
      "taskId": taskId,
      "description": description, // Ensure keys match your Firestore document
      "title": title,
    };
  }
}