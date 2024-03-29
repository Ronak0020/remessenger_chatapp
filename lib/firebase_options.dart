// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyB-iQMNXxKoLkqCRykpa7M8AVbLN8tq4sc',
    appId: '1:622953584700:web:e035a3951a00f3c04acb39',
    messagingSenderId: '622953584700',
    projectId: 'remessenger-4a202',
    authDomain: 'remessenger-4a202.firebaseapp.com',
    storageBucket: 'remessenger-4a202.appspot.com',
    measurementId: 'G-8CBZ9YZDNM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCSvX55AgxkAjBdewSGjANhm3vEWHIAfcw',
    appId: '1:622953584700:android:7714f261315e9c644acb39',
    messagingSenderId: '622953584700',
    projectId: 'remessenger-4a202',
    storageBucket: 'remessenger-4a202.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD9_W_vfQfbTU1YAHLYEnXNE7F5TExJodI',
    appId: '1:622953584700:ios:29ad88700f7f98ec4acb39',
    messagingSenderId: '622953584700',
    projectId: 'remessenger-4a202',
    storageBucket: 'remessenger-4a202.appspot.com',
    iosBundleId: 'com.ronakdev.remessenger',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD9_W_vfQfbTU1YAHLYEnXNE7F5TExJodI',
    appId: '1:622953584700:ios:5c8ba8720233cc874acb39',
    messagingSenderId: '622953584700',
    projectId: 'remessenger-4a202',
    storageBucket: 'remessenger-4a202.appspot.com',
    iosBundleId: 'com.ronakdev.remessenger.RunnerTests',
  );
}
