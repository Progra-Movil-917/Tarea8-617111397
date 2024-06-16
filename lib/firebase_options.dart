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
    apiKey: 'AIzaSyAOd6P15sJqwyN8PAgCtMPKTMVsqnmo9fY',
    appId: '1:551407552389:web:c36d48883dbf79830666ec',
    messagingSenderId: '551407552389',
    projectId: 'notas-25cc3',
    authDomain: 'notas-25cc3.firebaseapp.com',
    storageBucket: 'notas-25cc3.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBMpcRtYgxMcPJ5E94Za6mU3p2Y_HV2ak8',
    appId: '1:551407552389:android:2f3fa9ba932b5ec00666ec',
    messagingSenderId: '551407552389',
    projectId: 'notas-25cc3',
    storageBucket: 'notas-25cc3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAKNTmwpGXPnng8ZfXsPzYjAIhOaALqD2k',
    appId: '1:551407552389:ios:ba2705c0ea4fdfd40666ec',
    messagingSenderId: '551407552389',
    projectId: 'notas-25cc3',
    storageBucket: 'notas-25cc3.appspot.com',
    iosBundleId: 'com.example.tarea8',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAKNTmwpGXPnng8ZfXsPzYjAIhOaALqD2k',
    appId: '1:551407552389:ios:ba2705c0ea4fdfd40666ec',
    messagingSenderId: '551407552389',
    projectId: 'notas-25cc3',
    storageBucket: 'notas-25cc3.appspot.com',
    iosBundleId: 'com.example.tarea8',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAOd6P15sJqwyN8PAgCtMPKTMVsqnmo9fY',
    appId: '1:551407552389:web:f07405237f9baa880666ec',
    messagingSenderId: '551407552389',
    projectId: 'notas-25cc3',
    authDomain: 'notas-25cc3.firebaseapp.com',
    storageBucket: 'notas-25cc3.appspot.com',
  );
}
