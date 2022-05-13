// ignore_for_file: implementation_imports, use_key_in_widget_constructors

import 'package:book_proj/books/books_page.dart';
import 'package:book_proj/log_in/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class AuthorizedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context.read<AuthCubit>().signOut();
                },
              ),
            ],
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Words',
                ),
                Tab(text: 'Quotes'),
              ],
            ),
            title: const Text('Books'),
            toolbarHeight: 32,
          ),
          body: const TabBarView(
            children: [
              BooksPage(tabName: 'Words'),
              BooksPage(tabName: 'Quotes')
            ],
          ),
        ),
      ),
    );
  }
}
