import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:login_firebase_bloc_example/firebase_options.dart';
import 'package:login_firebase_bloc_example/views/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}





























