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
    apiKey: 'AIzaSyCtflRnKgWyZMBcwHTzIzZvtHSlCWkTuPc',
    appId: '1:738513365262:web:073575ec5f168741c64f5f',
    messagingSenderId: '738513365262',
    projectId: 'cluedin-79346',
    authDomain: 'cluedin-79346.firebaseapp.com',
    storageBucket: 'cluedin-79346.appspot.com',
    measurementId: 'G-SXF3936NXG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBaF4mR5tiBqxZV_pSJAffV8HkvADcAHmU',
    appId: '1:738513365262:android:479941caddf06ddec64f5f',
    messagingSenderId: '738513365262',
    projectId: 'cluedin-79346',
    storageBucket: 'cluedin-79346.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyButVR3qthk0WnZ29JVkuGKh1nuFRojbF4',
    appId: '1:738513365262:ios:4310873fbcae1cf5c64f5f',
    messagingSenderId: '738513365262',
    projectId: 'cluedin-79346',
    storageBucket: 'cluedin-79346.appspot.com',
    androidClientId:
        '738513365262-0nggp1bg9sknlncattmk1qukdg9fptk8.apps.googleusercontent.com',
    iosClientId:
        '738513365262-ufmgl73msvd7p76m92d09dclo1btap0t.apps.googleusercontent.com',
    iosBundleId: 'com.example.cluedinApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyButVR3qthk0WnZ29JVkuGKh1nuFRojbF4',
    appId: '1:738513365262:ios:4310873fbcae1cf5c64f5f',
    messagingSenderId: '738513365262',
    projectId: 'cluedin-79346',
    storageBucket: 'cluedin-79346.appspot.com',
    androidClientId:
        '738513365262-0nggp1bg9sknlncattmk1qukdg9fptk8.apps.googleusercontent.com',
    iosClientId:
        '738513365262-ufmgl73msvd7p76m92d09dclo1btap0t.apps.googleusercontent.com',
    iosBundleId: 'com.example.cluedinApp',
  );
}
