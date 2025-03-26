import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'No web options have been provided for this project',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'No iOS options have been provided for this project',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAoTqETaUmCdhdZPCkw2zhwDlCOgo-ijsI',
    appId: '1:546375098415:android:cc91b9d2ca2b81bc9a26da',
    messagingSenderId: '546375098415',
    projectId: 'expense-tracker-57498',
    storageBucket: 'expense-tracker-57498.firebasestorage.app',
  );
}
