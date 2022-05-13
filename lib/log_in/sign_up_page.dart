// ignore_for_file: use_key_in_widget_constructors, sized_box_for_whitespace, curly_braces_in_flow_control_structures, unnecessary_new

import 'package:book_proj/log_in/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatelessWidget {
  final firstName = TextEditingController();
  final telephone = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.yellow[400],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'First Name',
                          ),
                          controller: firstName,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          validator: (value) {
                            if (value!.length != 9) {
                              return 'Telephone must contain 9 characters';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Telephone',
                          ),
                          controller: telephone,
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          validator: (value) {
                            String pattern = r'.+@(mail\.ru|gmail\.com)$';
                            RegExp regex = new RegExp(pattern);
                            if (!regex.hasMatch(value!))
                              return 'Email should be {string}.@mail.ru or {string}.@gmail.com';
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Email',
                          ),
                          controller: email,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          validator: (value) {
                            if (value!.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Password',
                          ),
                          controller: password,
                        ),
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.only(left: 32.0),
                          child: Row(children: [
                            ElevatedButton(
                              child: const Text('Back'),
                              onPressed: () {
                                context.read<AuthCubit>().canselSignUp();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.purple),
                              ),
                            ),
                            const SizedBox(width: 120),
                            _AcceptSignUpButton(
                              firstName: firstName,
                              telephone: telephone,
                              email: email,
                              password: password,
                              keyGlobal: _formKey,
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //),
            ),
          );
        },
      ),
    );
  }
}

class _AcceptSignUpButton extends StatelessWidget {
  const _AcceptSignUpButton({
    Key? key,
    required this.firstName,
    required this.telephone,
    required this.email,
    required this.password,
    required this.keyGlobal,
  }) : super(key: key);
  final TextEditingController firstName;
  final TextEditingController telephone;
  final TextEditingController email;
  final TextEditingController password;
  final GlobalKey<FormState> keyGlobal;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return ElevatedButton(
          child: const Text('Accept'),
          onPressed: () {
            if (keyGlobal.currentState!.validate()) {
              FocusScope.of(context).unfocus();
              context.read<AuthCubit>().trySignUp(
                  email.text, password.text, firstName.text, telephone.text);
            }
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
