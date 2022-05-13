// ignore_for_file: prefer_initializing_formals, unnecessary_this

import 'dart:async';

import 'package:book_proj/data/collocation.dart';
import 'package:book_proj/data/words_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollocationsCubit extends Cubit<CollocationsState> {
  CollocationsCubit(
      {required BooksDataSource wordsDataSource, required String tabName})
      : _wordsDataSource = wordsDataSource,
        this.tabName = tabName,
        super(const CollocationsInitialState()) {
    _sub = _wordsDataSource.collocationStream(tabName).listen((collocations) =>
        emit(CollocationsLoadedState(
            collocations: collocations.reversed.toList())));
  }

  final BooksDataSource _wordsDataSource;
  late final StreamSubscription _sub;
  final String tabName;
  String? author;
  String? name;
  String? id;
  bool? newBook;
  DateTime? timestamp;

  Future<void> refresh() async {
    final collocations = await _wordsDataSource.getCollocations(tabName);
    emit(CollocationsLoadedState(
      collocations: collocations.reversed.toList(),
    ));
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}

abstract class CollocationsState {
  const CollocationsState();
}

class CollocationsInitialState extends CollocationsState {
  const CollocationsInitialState();
}

class CollocationsLoadedState extends CollocationsState {
  const CollocationsLoadedState({
    required this.collocations,
  });

  final List<Collocation> collocations;
}
