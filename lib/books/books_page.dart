// ignore_for_file: prefer_initializing_formals, prefer_const_constructors, unnecessary_this

import 'package:book_proj/books/books_cubit.dart';
import 'package:book_proj/books/dropdowns.dart';
import 'package:book_proj/log_in/auth_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:book_proj/data/words_data_source.dart';
import 'package:book_proj/data/book.dart';

import 'add_book_page.dart';
import 'collocations/collocation_change_page.dart';
import 'collocations/collocations_page.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({Key? key, required String tabName})
      : this.tabName = tabName,
        super(key: key);
  final String tabName;
  @override
  Widget build(BuildContext context) {
    final value = (context.read<AuthCubit>().getSignedUser());
    return Scaffold(
      body: FutureBuilder(
          future: value,
          builder: (ctx, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Provider(
                  create: (_) => BooksDataSource(
                    firestore: FirebaseFirestore.instance,
                    idOfsignedUser: context.read<AuthCubit>().getID(),
                  ),
                  child: BlocProvider(
                    create: (context) => BooksCubit(
                      booksDataSource: context.read(),
                      tabName: tabName,
                    )..refresh(),
                    child: BooksGate(),
                  ),
                );
              default:
                return const ColoredBox(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ),
                );
            }
          }),
    );
  }
}

class BooksGate extends StatelessWidget {
  const BooksGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BooksCubit, BooksState>(
      builder: (context, state) {
        if (state is AddingBookState)
          // ignore: curly_braces_in_flow_control_structures
          return AddBookPage(
            author: context.read<BooksCubit>().bookToBeAdded!.author,
            name: context.read<BooksCubit>().bookToBeAdded!.name,
            category: context.read<BooksCubit>().bookToBeAdded!.category,
          );
        if (state is ContentViewState) return CollocationsPage();
        if (state is ContentChangeState)
          // ignore: curly_braces_in_flow_control_structures
          return CollocationChangePage(
            Content: context.read<BooksCubit>().selectedCollocation!.content,
          );
        return BooksViewPage(Category: context.read<BooksCubit>().category);
      },
    );
  }
}

class BooksViewPage extends StatelessWidget {
  const BooksViewPage({Key? key, required String Category})
      : category = Category,
        super(key: key);
  final String category;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BooksCubit, BooksState>(builder: (context, state) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.yellow[400],
        ),
        child: Column(
          children: [
            Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.red[500],
                ),
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    Text(
                      'Category:',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 16),
                    CategoryDropdown(Category: category),
                    SizedBox(width: 16),
                    Text(
                      'OrderBy:',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 16),
                    OrderByDropdown(),
                    context.read<BooksCubit>().getDescending()
                        ? IconButton(
                            icon: const Icon(Icons.arrow_circle_up),
                            color: Colors.white,
                            onPressed: () =>
                                context.read<BooksCubit>().changeDescending(),
                          )
                        : IconButton(
                            icon: const Icon(Icons.arrow_circle_down),
                            color: Colors.white,
                            onPressed: () =>
                                context.read<BooksCubit>().changeDescending(),
                          ),
                  ],
                )),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: _ListOfBooks(),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.purple[400],
                    ),
                    child: IconButton(
                        icon: const Icon(Icons.add_box),
                        onPressed: () => context.read<BooksCubit>().addBook(
                            null, '', '', DateTime.now(), '', 'All', true)
                        //),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _ListOfBooks extends StatelessWidget {
  const _ListOfBooks({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: context.watch<BooksCubit>().refresh,
      child: BlocBuilder<BooksCubit, BooksState>(
        builder: (context, state) {
          if (state is BooksLoadedState) {
            return ListView.builder(
              itemCount: state.books.length,
              itemBuilder: (_, i) => _Books(
                book: state.books[i],
              ),
              reverse: false,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class _Books extends StatelessWidget {
  _Books({
    Key? key,
    required this.book,
  }) : super(key: key);

  final df = DateFormat.Hm();
  final Book book;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<BooksCubit>().selectBook(book);
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          color: Colors.blueGrey[100],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            book.imagePath == ''
                ? SizedBox(
                    width: 50,
                    height: 50,
                  )
                : Image.network(
                    book.imagePath,
                    height: 50,
                    width: 50,
                  ),
            Expanded(
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text(
                    'Author : ',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.red,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      book.author,
                      style: const TextStyle(
                          fontSize: 24,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Name : ',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.deepOrange[600],
                    ),
                  ),
                  Flexible(
                    child: Text(
                      book.name,
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.deepOrange[600],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Category : ',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.deepOrange[600],
                    ),
                  ),
                  Flexible(
                    child: Text(
                      book.category,
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.deepOrange[600],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
              ]),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.construction),
                  onPressed: () => context.read<BooksCubit>().addBook(
                      book.id,
                      book.author,
                      book.name,
                      book.timestamp,
                      book.imagePath,
                      book.category,
                      false),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_forever),
                  onPressed: () =>
                      context.read<BooksCubit>().deleteBook(book.id!),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
