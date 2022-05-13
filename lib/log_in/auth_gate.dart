// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, use_key_in_widget_constructors, sized_box_for_whitespace, unnecessary_new

import 'package:book_proj/log_in/authorized_page.dart';
import 'package:book_proj/log_in/sign_up_page.dart';
import 'package:book_proj/log_in/unathorized_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../animation_page.dart';
import 'auth_cubit.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (context.read<AuthCubit>().toAddId!)
          context.read<AuthCubit>().addId();
        if (state is SignedInState) {
          final value = (context.read<AuthCubit>().getSignedUser());
          return FutureBuilder(
              future: value,
              builder: (ctx, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return AnimationPage(
                      authCubit: ctx.read<AuthCubit>(),
                      firstName: ctx.read<AuthCubit>().getFirstName(),
                      telephone: ctx.read<AuthCubit>().getTelephone(),
                    );
                  default:
                    return const ColoredBox(
                      color: Colors.white,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.purple,
                        ),
                      ),
                    );
                }
              });
        }
        if (state is SignedInViewState) return AuthorizedPage();
        if (state is SignUpState) return SignUpPage();
        return UnauthorizedPage();
      },
    );
  }
}
