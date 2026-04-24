import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDB-czTSqRTeqe0pnVyPppqbLFfpWcy1RY",
            authDomain: "eduera-7d152.firebaseapp.com",
            projectId: "eduera-7d152",
            storageBucket: "eduera-7d152.firebasestorage.app",
            messagingSenderId: "228303241113",
            appId: "1:228303241113:web:1730a84fdb11895d111d08",
            measurementId: "G-FSE4KM6RET"));
  } else {
    await Firebase.initializeApp();
  }
}
