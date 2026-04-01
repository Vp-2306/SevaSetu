import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError('Unsupported platform');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAZazwodkwc27DKAhrvZoxsY1DN9JFhk6I",
    authDomain: "sevasetu-70eea.firebaseapp.com",
    projectId: "sevasetu-70eea",
    storageBucket: "sevasetu-70eea.firebasestorage.app",
    messagingSenderId: "272406598921",
    appId: "1:272406598921:web:7b87fa1558183f1f34afd8"
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBNIuXVtsVdsxFeyDjG52sSwJ-mKARjpSw',
    appId: '1:272406598921:android:4bd6345439d1ef0834afd8',
    messagingSenderId: '272406598921',
    projectId: 'sevasetu-70eea',
    storageBucket: 'sevasetu-70eea.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAvhw7JWw68O0veP-xWQmMhnumrEb2uAGA',
    appId: '1:272406598921:ios:deb28a839f60e03434afd8',
    messagingSenderId: '272406598921',
    projectId: 'sevasetu-70eea',
    storageBucket: 'sevasetu-70eea.firebasestorage.app',
    iosBundleId: 'com.sevasetu.sevasetu',
  );
}