// ignore_for_file: unnecessary_this, prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables, no_logic_in_create_state

import 'dart:io';

import 'package:book_proj/books/books_cubit.dart';
import 'package:book_proj/data/pick_my_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class AddBookPage extends StatefulWidget {
  AddBookPage(
      {Key? key,
      required this.author,
      required this.name,
      required this.category})
      : super(key: key);
  final author;
  final name;
  final category;
  @override
  State<AddBookPage> createState() => _AddBookPageState(author, name, category);
}

class _AddBookPageState extends State<AddBookPage> {
  // ignore: non_constant_identifier_names
  _AddBookPageState(String? Author, String? Name, String category) {
    author.text = Author!;
    name.text = Name!;
    dropdownValue = category;
  }
  final author = TextEditingController();
  final name = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future<File?>? pathName;
  String? dropdownValue;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BooksCubit, BooksState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Expanded(
            // ignore: sized_box_for_whitespace
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
                              return 'Please enter the author of book';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Author',
                          ),
                          controller: author,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the name of book';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Name',
                          ),
                          controller: name,
                        ),
                        const SizedBox(height: 16),
                        DropdownButton<String>(
                          value: dropdownValue,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          items: <String>[
                            'All',
                            'Biography',
                            'Fiction',
                            'Poetry'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: 60.0,
                          height: 60.0,
                          child: IconButton(
                              icon: const Icon(Icons.photo_camera_rounded),
                              onPressed: () {
                                context
                                    .read<BooksCubit>()
                                    .setFutureImagePath(PickMyImage.getImage());
                              }),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 32.0),
                          child: Row(children: [
                            ElevatedButton(
                              child: const Text('Back'),
                              onPressed: () {
                                context.read<BooksCubit>().canselAdding();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.purple),
                              ),
                            ),
                            const SizedBox(width: 120),
                            _AcceptButton(
                              author: author,
                              name: name,
                              pathName: this.pathName,
                              category: dropdownValue!,
                              keyGlobal: _formKey,
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AcceptButton extends StatelessWidget {
  const _AcceptButton({
    Key? key,
    required this.author,
    required this.name,
    required this.pathName,
    required this.category,
    required this.keyGlobal,
  }) : super(key: key);
  final TextEditingController author;
  final TextEditingController name;
  final Future<File?>? pathName;
  final GlobalKey<FormState> keyGlobal;
  final String category;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BooksCubit, BooksState>(builder: (context, state) {
      return ElevatedButton(
        child: const Text('Accept'),
        onPressed: () {
          if (keyGlobal.currentState!.validate()) {
            if (context.read<BooksCubit>().isAddingNewBook!)
              // ignore: curly_braces_in_flow_control_structures
              context.read<BooksCubit>().sendNewBook(
                    author.text,
                    name.text,
                    context.read<BooksCubit>().bookToBeAdded!.timestamp,
                    category,
                  );
            else
              // ignore: curly_braces_in_flow_control_structures
              context.read<BooksCubit>().sendExistingBook(
                    context.read<BooksCubit>().bookToBeAdded!.id!,
                    author.text,
                    name.text,
                    context.read<BooksCubit>().bookToBeAdded!.timestamp,
                    category,
                  );
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.purple),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
      );
    });
  }
}
