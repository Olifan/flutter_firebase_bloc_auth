import 'package:flutter_firebase_bloc_auth/blocs/authentication_bloc/authentication_state.dart';
import 'package:flutter_firebase_bloc_auth/blocs/simple_bloc_observer.dart';
import 'package:flutter_firebase_bloc_auth/repositories/user_repository.dart';
import 'package:flutter_firebase_bloc_auth/screens/home_screen.dart';
import 'package:flutter_firebase_bloc_auth/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/authentication_bloc/authentication_bloc.dart';
import 'blocs/authentication_bloc/authentication_event.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(
        userRepository: userRepository,
      )..add(AuthenticationStarted()),
      child: MyApp(
        userRepository: userRepository,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;

  MyApp({UserRepository userRepository}) : _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    var themeData = ThemeData(
        primaryColor: Color(0xff6a515e),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xff6a515e),
          )
      );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: themeData,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationFailure) {
            return LoginScreen(
              userRepository: _userRepository,
            );
          }

          if (state is AuthenticationSuccess) {
            return HomeScreen(
              user: state.firebaseUser,
            );
          }

          return Scaffold(
            appBar: AppBar(),
            body: Container(
              child: Center(child: Text("Loading")),
            ),
          );
        },
      ),
    );
  }
}
