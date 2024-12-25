import 'package:cloud_firestore/cloud_firestore.dart';
import '../Books.dart';
import '../Tasks.dart';
import '../User.dart';

// A handler class for Firestore operations, providing methods to interact with Firestore collections and documents
class FirestoreHandler {
  // Method to get a reference to the user collection in Firestore with a converter for the User model
  static CollectionReference<User> getUserCollection() {
    var firestore = FirebaseFirestore.instance; // Access the Firestore instance
 
    // Create a reference to the 'users' collection with custom converters for User objects
    var collection = firestore.collection(User.collection).withConverter<User>(
      fromFirestore: (snapshot, options) {
        var data = snapshot.data(); // Extract the data from the Firestore snapshot
        print('fromFirestore: $data'); // Debug print for data from Firestore
        return User.fromFirestore(data); // Convert Firestore data to a User object
      },
      toFirestore: (user, options) {
        var data = user.toFirestore(); // Convert a User object to Firestore-compatible data
        print('toFirestore: $data'); // Debug print for data being sent to Firestore
        return data;
      },
    );

    return collection; // Return the configured collection reference
  }

  // Method to create a new user document in the 'users' collection
  static Future<void> createUser(User user) async {
    try {
      print('Attempting to create Firestore document for user ID: ${user.id}');
      var collection = getUserCollection(); // Get the user collection reference
      var docRef = collection.doc(user.id); // Get a document reference for the user ID

      await docRef.set(user); // Add the user data to Firestore
      print('User document successfully added to Firestore.');
    } catch (e) {
      print('Error creating user in Firestore: $e'); // Print error if creation fails
      rethrow; // Re-throw the error for further handling
    }
  }

  // Method to create a new task linked to a specific user
  static Future<void> createTask(String userId, Task task) async {
    try {
      print('Attempting to create task for user ID: $userId');

      // Reference the user's tasks subcollection
      var tasksCollection = getUserCollection()
          .doc(userId)
          .collection(Task.collection)
          .withConverter<Task>(
        fromFirestore: (snapshot, options) {
          var data = snapshot.data(); // Extract Firestore snapshot data
          print('fromFirestore (Task): $data'); // Debug print
          return Task.fromFirestore(data); // Convert Firestore data to a Task object
        },
        toFirestore: (task, options) {
          var data = task.toFirestore(); // Convert a Task object to Firestore-compatible data
          print('toFirestore (Task): $data'); // Debug print
          return data;
        },
      );

      // Create a new document in the tasks subcollection with a unique ID
      var newTaskRef = tasksCollection.doc();
      task.taskId = newTaskRef.id; // Assign the generated ID to the task object

      // Save the task data to Firestore
      await newTaskRef.set(task);
      print('Task successfully added to Firestore.');
    } catch (e) {
      print('Error creating task in Firestore: $e'); // Print error if task creation fails
      rethrow; // Re-throw the error for further handling
    }
  }

  // Method to stream all tasks for a specific user in real-time
  static Stream<List<Task>> getUserTasks(String userId) {
    // Reference the user's tasks subcollection with converters
    var tasksCollection = getUserCollection()
        .doc(userId)
        .collection(Task.collection)
        .withConverter<Task>(
      fromFirestore: (snapshot, options) {
        var data = snapshot.data(); // Extract snapshot data
        return Task.fromFirestore(data); // Convert Firestore data to a Task object
      },
      toFirestore: (task, options) => task.toFirestore(), // Convert Task object to Firestore data
    );

    // Map Firestore snapshots to a list of Task objects
    return tasksCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) => doc.data()).toList(); // Extract Task objects from snapshot
    });
  }

  // Method to add a new book linked to a specific user
  static Future<void> addbook(String userID, Books book) async {
    try {
      // Reference the user's books subcollection with converters
      var BooksCollection = getUserCollection()
          .doc(userID)
          .collection(Books.collection)
          .withConverter<Books>(
          fromFirestore: (snapshot, options) {
            var data = snapshot.data(); // Extract snapshot data
            return Books.fromFirestore(data); // Convert Firestore data to a Books object
          },
          toFirestore: (Books, options) {
            var data = Books.toFirestore(); // Convert Books object to Firestore-compatible data
            return data;
          }
      );

      // Create a new document in the books subcollection with a unique ID
      var NewBookRef = BooksCollection.doc();
      book.BookID = NewBookRef.id; // Assign the generated ID to the book object

      // Save the book data to Firestore
      await NewBookRef.set(book);
    } catch (e) {
      print("Error adding book: $e"); // Print error if book addition fails
    }
  }
}