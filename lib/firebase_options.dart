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
    apiKey: 'AIzaSyDeAebP2fJaPgwWjHrNSI5tQyLyDZVSziE',
    appId: '1:279011276775:web:fe17a659be0120b60eef42',
    messagingSenderId: '279011276775',
    projectId: 'smartshop-f17e0',
    authDomain: 'smartshop-f17e0.firebaseapp.com',
    storageBucket: 'smartshop-f17e0.appspot.com',
    measurementId: 'G-ZR3VK92EHK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDSS8vi28MnP6vA6B121XJBa-G5hQPdINE',
    appId: '1:279011276775:android:3a4149107e3c75ff0eef42',
    messagingSenderId: '279011276775',
    projectId: 'smartshop-f17e0',
    storageBucket: 'smartshop-f17e0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDkckFynC6CRrsSiakepELXBWZ2uLtl6Hw',
    appId: '1:279011276775:ios:f4e622ad2a29cee40eef42',
    messagingSenderId: '279011276775',
    projectId: 'smartshop-f17e0',
    storageBucket: 'smartshop-f17e0.appspot.com',
    iosBundleId: 'com.example.smartshop',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDkckFynC6CRrsSiakepELXBWZ2uLtl6Hw',
    appId: '1:279011276775:ios:f4e622ad2a29cee40eef42',
    messagingSenderId: '279011276775',
    projectId: 'smartshop-f17e0',
    storageBucket: 'smartshop-f17e0.appspot.com',
    iosBundleId: 'com.example.smartshop',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDeAebP2fJaPgwWjHrNSI5tQyLyDZVSziE',
    appId: '1:279011276775:web:a25367b0ad1a7e790eef42',
    messagingSenderId: '279011276775',
    projectId: 'smartshop-f17e0',
    authDomain: 'smartshop-f17e0.firebaseapp.com',
    storageBucket: 'smartshop-f17e0.appspot.com',
    measurementId: 'G-V4HHB778CH',
  );
}
