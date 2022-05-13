// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:book_proj/data/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_service.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authService})
      : super(authService.isSignedIn
            ? const SignedInState()
            : const SignedOutState()) {
    _sub = authService.isSignedInStream.listen((isSignedIn) {
      emit(isSignedIn ? const SignedInState() : const SignedOutState());
    });
  }

  final AuthService authService;
  StreamSubscription? _sub;
  UserOwn? signedUser;
  String? nameOfSignedUser;
  String? phoneOfSignedUser;
  String? nameToBeAdded;
  String? telephoneToBeAdded;
  bool? toAddId = false;

  Future<void> signInWithEmail(
    String email,
    String password,
  ) async {
    emit(const SigningInState());
    await Future.delayed(const Duration(seconds: 1));

    try {
      final res = await authService.signInWithEmail(email, password);

      switch (res) {
        case SignInResult.success:
          emit(const SignedInState());
          break;
        case SignInResult.emailAlreadyInUse:
          emit(const SignedOutState(
              error: 'This email address is already in use.'));
          break;
        case SignInResult.invalidEmail:
          emit(const SignedOutState(error: 'This email address is invalid.'));
          break;
        case SignInResult.userNotFound:
          break;
        case SignInResult.wrongPassword:
          emit(const SignedOutState(error: 'Invalid credentials.'));
          break;
      }
    } catch (_) {
      emit(const SignedOutState(error: 'Unexpected error.'));
    }
  }

  Future<void> signOut() async {
    await authService.signOut();

    emit(const SignedOutState());
  }

  Future<void> signUpForm() async {
    emit(const SigningUpState());
    await Future.delayed(const Duration(seconds: 1));
    emit(const SignUpState());
  }

  Future<void> trySignUp(
      String email, String password, String firstName, String telephone) async {
    toAddId = true;
    nameToBeAdded = firstName;
    telephoneToBeAdded = telephone;
    authService.signUpWithEmail(email, password);
  }

  Future<void> canselSignUp() async {
    emit(SignedOutState());
  }

  Future<void> addId() async {
    toAddId = false;
    authService.addId(nameToBeAdded!, telephoneToBeAdded!);
  }

  Future<UserOwn?> getSignedUser() async {
    return authService.signedUser();
  }

  String getFirstName() {
    return authService.getSignedUserData()!.firstName;
  }

  String getTelephone() {
    return authService.getSignedUserData()!.telephone;
  }

  String getID() {
    return authService.getSignedUserData()!.id!;
  }

  Future<void> endTheAnimation() async {
    emit(const SignedInViewState());
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}

abstract class AuthState {
  const AuthState();
}

class SignedInState extends AuthState {
  const SignedInState();
}

class SignedInViewState extends AuthState {
  const SignedInViewState();
}

class SigningInState extends AuthState {
  const SigningInState();
}

class SignedOutState extends AuthState {
  const SignedOutState({
    this.error,
  });

  final String? error;
}

class SigningUpState extends AuthState {
  const SigningUpState();
}

class SignUpState extends AuthState {
  const SignUpState();
}
