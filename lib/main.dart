// ignore_for_file: use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'log_in/auth_cubit.dart';
import 'log_in/auth_service.dart';
import 'log_in/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jobs',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Provider(
        create: (_) => AuthService(
          firebaseAuth: FirebaseAuth.instance,
          firestore: FirebaseFirestore.instance,
        ),
        child: BlocProvider(
          create: (ctx) => AuthCubit(
            authService: ctx.read(),
          ),
          child: MaterialApp(
            title: 'LogInPage',
            theme: ThemeData(
              primarySwatch: Colors.purple,
            ),
            // ignore: prefer_const_constructors
            home: Scaffold(
              body: const AuthGate(),
            ),
          ),
        ),
      ),
    );
  }
}
