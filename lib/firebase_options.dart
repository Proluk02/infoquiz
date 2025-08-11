// Ce fichier contient la configuration Firebase pour chaque plateforme (web, android, ios, etc.)
// Il est généré automatiquement par l'outil FlutterFire CLI.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Classe utilitaire qui fournit les options Firebase selon la plateforme
/// Permet d'initialiser Firebase facilement dans le code principal
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // Retourne la configuration web si on est sur navigateur
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
          'DefaultFirebaseOptions have not been configuré pour linux - '
          'vous pouvez reconfigurer cela en relançant FlutterFire CLI.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions ne sont pas supportées pour cette plateforme.',
        );
    }
  }

  // Configuration pour le web
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCklrCXkIlYjjmPxGi_5ie1mi6lvSbQoFI',
    appId: '1:695780553357:web:0548d59aaa8e41399c28c4',
    messagingSenderId: '695780553357',
    projectId: 'infoquiz-1b6d8',
    authDomain: 'infoquiz-1b6d8.firebaseapp.com',
    storageBucket: 'infoquiz-1b6d8.firebasestorage.app',
    measurementId: 'G-D2LZVC374W',
  );

  // Configuration pour Android
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAlNXwKylkSnKMk6VYzZTt1ZzB6TIk2wkM',
    appId: '1:695780553357:android:a71ba5b5951109bf9c28c4',
    messagingSenderId: '695780553357',
    projectId: 'infoquiz-1b6d8',
    storageBucket: 'infoquiz-1b6d8.firebasestorage.app',
  );

  // Configuration pour iOS
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCyZjot4n7pQ75lfUM-qGALouVZKwADz9A',
    appId: '1:695780553357:ios:56ea0047f02760fa9c28c4',
    messagingSenderId: '695780553357',
    projectId: 'infoquiz-1b6d8',
    storageBucket: 'infoquiz-1b6d8.firebasestorage.app',
    iosClientId:
        '695780553357-8tk9ghtal6m51netao7t2o0999ilq0iv.apps.googleusercontent.com',
    iosBundleId: 'com.example.infoquiz',
  );

  // Configuration pour macOS
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCyZjot4n7pQ75lfUM-qGALouVZKwADz9A',
    appId: '1:695780553357:ios:56ea0047f02760fa9c28c4',
    messagingSenderId: '695780553357',
    projectId: 'infoquiz-1b6d8',
    storageBucket: 'infoquiz-1b6d8.firebasestorage.app',
    iosClientId:
        '695780553357-8tk9ghtal6m51netao7t2o0999ilq0iv.apps.googleusercontent.com',
    iosBundleId: 'com.example.infoquiz',
  );

  // Configuration pour Windows
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCklrCXkIlYjjmPxGi_5ie1mi6lvSbQoFI',
    appId: '1:695780553357:web:2494d6a1e28a601e9c28c4',
    messagingSenderId: '695780553357',
    projectId: 'infoquiz-1b6d8',
    authDomain: 'infoquiz-1b6d8.firebaseapp.com',
    storageBucket: 'infoquiz-1b6d8.firebasestorage.app',
    measurementId: 'G-YTLCWHJTY6',
  );
}
