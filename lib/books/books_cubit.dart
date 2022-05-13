// ignore_for_file: unnecessary_this, prefer_const_constructors, prefer_initializing_formals

import 'dart:async';
import 'dart:io';
import 'package:book_proj/data/collocation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_proj/data/words_data_source.dart';
import 'package:book_proj/data/book.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BooksCubit extends Cubit<BooksState> {
  BooksCubit(
      {required BooksDataSource booksDataSource, required String tabName})
      : _booksDataSource = booksDataSource,
        this.tabName = tabName,
        super(const BooksInitialState()) {
    _sub = _booksDataSource
        .bookStream(tabName, category, sortBy, isDescending)
        .listen((books) => emit(BooksLoadedState(books: books.toList())));
  }

  final BooksDataSource _booksDataSource;
  final String tabName;
  late final StreamSubscription _sub;
  Book? selectedBook;
  Collocation? selectedCollocation;
  Book? bookToBeAdded;
  bool? isAddingNewBook;
  DateTime? timestamp;
  Future<File?>? futureImageFile;
  File? imageFile;
  String sortBy = 'Timestamp';
  bool isDescending = true;
  String category = 'All';

  Future<void> refresh() async {
    final books = await _booksDataSource.getBooks(
        tabName, category, sortBy, isDescending);
    emit(BooksLoadedState(
      books: books.toList(),
    ));
  }

  Future<void> sendNewBook(
      String author, String name, DateTime time, String category) async {
    if (futureImageFile != null) {
      imageFile = await futureImageFile;
      //String fileName = basename(_imageFile.path);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/${imageFile!.path}');
      UploadTask uploadTask = firebaseStorageRef.putFile(imageFile!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      //books

      _booksDataSource.sendNewBook(
          tabName,
          Book(
            id: null,
            author: author,
            name: name,
            timestamp: DateTime.now(),
            imagePath: await taskSnapshot.ref.getDownloadURL(),
            category: category,
          ));
      this.futureImageFile = null;
      this.imageFile = null;
    } else {
      _booksDataSource.sendNewBook(
          tabName,
          Book(
            id: null,
            author: author,
            name: name,
            timestamp: DateTime.now(),
            imagePath: '',
            category: category,
          ));
    }
    emit(BooksLoadedState(
        books: (await _booksDataSource.getBooks(
                tabName, this.category, sortBy, isDescending))
            .toList()));
  }

  Future<void> sendExistingBook(String id, String author, String name,
      DateTime time, String category) async {
    if (futureImageFile != null) {
      imageFile = await futureImageFile;
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/${imageFile!.path}');
      UploadTask uploadTask = firebaseStorageRef.putFile(imageFile!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      _booksDataSource.sendExistingBook(
          tabName,
          Book(
            id: id,
            author: author,
            name: name,
            timestamp: time,
            imagePath: await taskSnapshot.ref.getDownloadURL(),
            category: category,
          ));
      this.futureImageFile = null;
      this.imageFile = null;
    } else
      // ignore: curly_braces_in_flow_control_structures
      _booksDataSource.sendExistingBook(
          tabName,
          Book(
            id: id,
            author: author,
            name: name,
            timestamp: time,
            imagePath: bookToBeAdded!.imagePath,
            category: category,
          ));
    emit(BooksLoadedState(
        books: (await _booksDataSource.getBooks(
                tabName, this.category, sortBy, isDescending))
            .toList()));
  }

  Future<void> addBook(
      String? id,
      String author,
      String name,
      DateTime timestamp,
      String imagePath,
      String category,
      bool isAddingNewBook) async {
    bookToBeAdded = Book(
        id: id,
        author: author,
        name: name,
        timestamp: timestamp,
        imagePath: imagePath,
        category: category);
    this.isAddingNewBook = isAddingNewBook;
    emit(const AddingBookState());
  }

  Future<void> selectBook(Book book) async {
    this.selectedBook = book;
    _booksDataSource.selectBook(book);
    emit(ContentViewState());
  }

  Future<void> deleteBook(String id) async {
    _booksDataSource.deleteBook(tabName, id);
    emit(BooksLoadedState(
        books: (await _booksDataSource.getBooks(
                tabName, category, sortBy, isDescending))
            .toList()));
  }

  Future<void> canselAdding() async {
    emit(BooksLoadedState(
        books: (await _booksDataSource.getBooks(
                tabName, category, sortBy, isDescending))
            .toList()));
  }

  //collocations

  Future<void> sendCollocation(String text) async {
    _booksDataSource.sendCollocation(tabName, text);
  }

  Future<void> sendExistingCollocation(String text) async {
    _booksDataSource.sendExistingCollocation(tabName, text);
    emit(ContentViewState());
  }

  Future<void> selectCollocation(Collocation collocation) async {
    this.selectedCollocation = collocation;
    _booksDataSource.selectCollocation(collocation);
    emit(ContentChangeState());
  }

  Future<void> deleteCollocation(String id) async {
    _booksDataSource.deleteCollocation(tabName, id);
  }

  Future<void> canselChanging() async {
    emit(ContentViewState());
  }

  Future<void> viewBooks() async {
    emit(BooksLoadedState(
        books: (await _booksDataSource.getBooks(
                tabName, category, sortBy, isDescending))
            .toList()));
  }

  Future<void> setFutureImagePath(Future<File?> futureImagePath) async {
    this.futureImageFile = futureImagePath;
  }

  Future<void> changeOrder(String orderBy) async {
    this.sortBy = orderBy;
    emit(BooksLoadedState(
        books: (await _booksDataSource.getBooks(
                tabName, category, sortBy, isDescending))
            .toList()));
  }

  bool getDescending() => this.isDescending;

  Future<void> changeDescending() async {
    this.isDescending = !this.isDescending;
    emit(BooksLoadedState(
        books: (await _booksDataSource.getBooks(
                tabName, category, sortBy, isDescending))
            .toList()));
  }

  Future<void> changeCategory(String category) async {
    this.category = category;
    emit(BooksLoadedState(
        books: (await _booksDataSource.getBooks(
                tabName, category, sortBy, isDescending))
            .toList()));
  }

  @override
  Future<void> close() async {
    await _sub.cancel();
    return super.close();
  }
}

abstract class BooksState {
  const BooksState();
}

class BooksInitialState extends BooksState {
  const BooksInitialState();
}

class BooksLoadedState extends BooksState {
  const BooksLoadedState({
    required this.books,
  });

  final List<Book> books;
}

class AddingBookState extends BooksState {
  const AddingBookState();
}

class ContentViewState extends BooksState {
  const ContentViewState();
}

class ContentChangeState extends BooksState {
  const ContentChangeState();
}
