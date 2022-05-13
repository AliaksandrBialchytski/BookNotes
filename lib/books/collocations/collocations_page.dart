// ignore_for_file: use_key_in_widget_constructors

import 'package:book_proj/books/collocations/collocations_cubit.dart';
import 'package:book_proj/data/collocation.dart';
import 'package:book_proj/data/words_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../books_cubit.dart';

class CollocationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.read<BooksCubit>().viewBooks();
          },
        ),
        backgroundColor: Colors.red[500],
        title: Text(
            '${context.read<BooksCubit>().selectedBook!.author} : ${context.read<BooksCubit>().selectedBook!.name}'),
        toolbarHeight: 40,
      ),
      body: BlocProvider(
        create: (context) => CollocationsCubit(
          wordsDataSource: context.read<BooksDataSource>(),
          tabName: context.read<BooksCubit>().tabName,
        )..refresh(),
        child: const CollocationViewPage(),
        //),
        //),
      ),
    );
  }
}

class CollocationViewPage extends StatelessWidget {
  const CollocationViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollocationsCubit, CollocationsState>(
        builder: (context, state) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.yellow[400],
        ),
        child: Column(
          children: [
            // ignore: prefer_const_constructors
            Expanded(child: _ListOfCollocations()),
            _CollocationBox(),
          ],
        ),
      );
    });
  }
}

class _ListOfCollocations extends StatelessWidget {
  const _ListOfCollocations({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: context.watch<CollocationsCubit>().refresh,
      child: BlocBuilder<CollocationsCubit, CollocationsState>(
        builder: (context, state) {
          if (state is CollocationsLoadedState) {
            return ListView.builder(
              itemCount: state.collocations.length,
              itemBuilder: (_, i) => _Collocations(
                collocation: state.collocations[i],
              ),
              reverse: true,
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

class _Collocations extends StatelessWidget {
  _Collocations({
    Key? key,
    required this.collocation,
  }) : super(key: key);

  final df = DateFormat.Hm();
  final Collocation collocation;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: Colors.purple[100],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            Flexible(
              child: Text(
                collocation.content,
                style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            IconButton(
              icon: const Icon(Icons.construction),
              onPressed: () {
                context.read<BooksCubit>().selectCollocation(collocation);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () {
                context.read<BooksCubit>().deleteCollocation(collocation.id!);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CollocationBox extends StatelessWidget {
  final collocation = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.purple[200],
      ),
      child: Row(children: [
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter the collocation...',
            ),
            controller: collocation,
          ),
        ),
        IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              context.read<BooksCubit>().sendCollocation(collocation.text);
              FocusScope.of(context).unfocus();
              collocation.text = '';
            }),
      ]),
    );
    //);
  }
}
