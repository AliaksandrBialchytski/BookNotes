// ignore_for_file: prefer_const_constructors

import 'package:book_proj/log_in/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UnauthorizedPage extends StatelessWidget {
  UnauthorizedPage({Key? key}) : super(key: key);

  final email = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Sign in'),
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Colors.yellow[400],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Email address',
                    ),
                    controller: email,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Password',
                    ),
                    controller: password,
                  ),
                  const SizedBox(height: 16),
                  if (state is SignedOutState && state.error != null) ...[
                    Text(state.error!),
                    const SizedBox(height: 16),
                  ] else
                    const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: Row(
                      children: [
                        _SignUpButton(),
                        const SizedBox(width: 120),
                        _SignInButton(
                          email: email,
                          password: password,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SignInButton extends StatelessWidget {
  const _SignInButton({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  final TextEditingController email;
  final TextEditingController password;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return ElevatedButton(
          child: state is SigningInState
              ? const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Sign in'),
          onPressed: () {
            FocusScope.of(context).unfocus();
            if (state is SignedOutState)
              // ignore: curly_braces_in_flow_control_structures
              context
                  .read<AuthCubit>()
                  .signInWithEmail(email.text, password.text);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.purple),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return ElevatedButton(
          child: state is SigningUpState
              ? const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.purple,
                  ),
                )
              : const Text('Sign up'),
          onPressed: () {
            FocusScope.of(context).unfocus();
            if (state is SignedOutState) context.read<AuthCubit>().signUpForm();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.yellow[100]),
            foregroundColor: MaterialStateProperty.all(Colors.purple),
          ),
        );
      },
    );
  }
}
