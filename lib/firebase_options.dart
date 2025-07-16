// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, kIsWeb;
import 'dart:io' show Platform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'El entorno no está configurado para esta plataforma.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC7JHU-rPfx3tSH2dLme4dsBjMZ-IPhsAI',
    appId: '1:143676257857:android:3272133e7eb827fc3df8c0',
    messagingSenderId: '143676257857',
    projectId: 'iventrack',
    storageBucket: 'iventrack.appspot.com',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC7JHU-rPfx3tSH2dLme4dsBjMZ-IPhsAI',
    authDomain: 'iventrack.firebaseapp.com',
    projectId: 'iventrack',
    storageBucket: 'iventrack.appspot.com',
    messagingSenderId: '143676257857',
    appId: '1:143676257857:web:REEMPLAZA_ESTO', // <-- puedes dejarlo así o poner el correcto
  );
}
