// ignore_for_file: non_constant_identifier_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../books_cubit.dart';

class CollocationChangePage extends StatelessWidget {
  CollocationChangePage({String? Content}) {
    content.text = Content!;
  }

  final content = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BooksCubit, BooksState>(builder: (context, state) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.yellow[400],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the collocation';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Collocation',
                  ),
                  controller: content,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      child: const Text('Back'),
                      onPressed: () {
                        context.read<BooksCubit>().canselChanging();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.purple),
                      ),
                    ),
                    const SizedBox(width: 64),
                    ElevatedButton(
                      child: const Text('Accept'),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context
                              .read<BooksCubit>()
                              .sendExistingCollocation(content.text);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.purple),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
