// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAknK6H4ZZFFTze3hwajuH8Ywe8XEdWO0M',
    appId: '1:1061902507076:web:04a5be6e2f531ef6f37011',
    messagingSenderId: '1061902507076',
    projectId: 'todo-app-dokki-route',
    authDomain: 'todo-app-dokki-route.firebaseapp.com',
    storageBucket: 'todo-app-dokki-route.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBtN1UekJWtW5YzoM2Eikr5ZJck5qlrZCg',
    appId: '1:1061902507076:android:ddb02a25532f68b6f37011',
    messagingSenderId: '1061902507076',
    projectId: 'todo-app-dokki-route',
    storageBucket: 'todo-app-dokki-route.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA5exyfNE6ZCIsh7UQoDQLm3s63Yv71ymM',
    appId: '1:1061902507076:ios:cb61a72df7541ee1f37011',
    messagingSenderId: '1061902507076',
    projectId: 'todo-app-dokki-route',
    storageBucket: 'todo-app-dokki-route.firebasestorage.app',
    iosBundleId: 'com.example.todoApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA5exyfNE6ZCIsh7UQoDQLm3s63Yv71ymM',
    appId: '1:1061902507076:ios:cb61a72df7541ee1f37011',
    messagingSenderId: '1061902507076',
    projectId: 'todo-app-dokki-route',
    storageBucket: 'todo-app-dokki-route.firebasestorage.app',
    iosBundleId: 'com.example.todoApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAknK6H4ZZFFTze3hwajuH8Ywe8XEdWO0M',
    appId: '1:1061902507076:web:65f73a3fbf14adeef37011',
    messagingSenderId: '1061902507076',
    projectId: 'todo-app-dokki-route',
    authDomain: 'todo-app-dokki-route.firebaseapp.com',
    storageBucket: 'todo-app-dokki-route.firebasestorage.app',
  );

}