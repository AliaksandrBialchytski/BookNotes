// ignore_for_file: prefer_initializing_formals, avoid_function_literals_in_foreach_calls

import 'package:book_proj/data/collocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_proj/data/book.dart';

class BooksDataSource {
  BooksDataSource(
      {required FirebaseFirestore firestore, required String idOfsignedUser})
      : _firestore = firestore,
        this.idOfsignedUser = idOfsignedUser;

  final FirebaseFirestore _firestore;
  final String idOfsignedUser;
  Book? selectedBook;
  Collocation? selectedCollocation;

//books

  Stream<List<Book>> bookStream(
      String tabName, String category, String sortBy, bool isDescending) {
    if (category == 'All') {
      return _firestore
          .collection('Users')
          .doc(idOfsignedUser)
          .collection(tabName)
          .orderBy(
            sortBy,
            descending: isDescending,
          )
          .snapshots()
          .map((b) => b.docs.map(Book.fromSnapshot).toList());
    } else {
      return _firestore
          .collection('Users')
          .doc(idOfsignedUser)
          .collection(tabName)
          .orderBy(
            sortBy,
            descending: isDescending,
          )
          .snapshots()
          .map((b) {
        return b.docs
            .map(Book.fromSnapshot)
            .toList()
            .where((element) => element.category == category)
            .toList();
      });
    }
  }

  Future<List<Book>> getBooks(
      String tabName, String category, String sortBy, bool isDescending) async {
    if (category == 'All') {
      final books = await _firestore
          .collection('Users')
          .doc(idOfsignedUser)
          .collection(tabName)
          .orderBy(
            sortBy,
            descending: isDescending,
          )
          .get();
      return books.docs.map(Book.fromSnapshot).toList();
    } else {
      final words = (await _firestore
          .collection('Users')
          .doc(idOfsignedUser)
          .collection(tabName)
          .orderBy(
            sortBy,
            descending: isDescending,
          )
          .get());

      final list = (words).docs.map(Book.fromSnapshot).toList();
      List<Book> listMain = [];
      list.forEach((element) {
        if (element.category == category) listMain.add(element);
      });
      return listMain;
    }
  }

  Future<void> sendNewBook(String tabName, Book book) => _firestore
      .collection('Users')
      .doc(idOfsignedUser)
      .collection(tabName)
      .add(book.toMap());

  Future<void> sendExistingBook(String tabName, Book book) async {
    _firestore
        .collection('Users')
        .doc(idOfsignedUser)
        .collection(tabName)
        .doc(book.id)
        .update({
      'Author': book.author,
      'Name': book.name,
      'Timestamp': book.timestamp,
      'ImagePath': book.imagePath,
      'Category': book.category,
    });
  }

  Future<void> selectBook(Book book) async {
    selectedBook = book;
  }

  Future<void> deleteBook(String tabName, String id) async {
    _firestore
        .collection('Users')
        .doc(idOfsignedUser)
        .collection(tabName)
        .doc(id)
        .delete();
  }

  //collocations

  Stream<List<Collocation>> collocationStream(String tabName) {
    return _firestore
        .collection('Users')
        .doc(idOfsignedUser)
        .collection(tabName)
        .doc(selectedBook!.id)
        .collection('Collocations')
        .orderBy('Timestamp')
        .snapshots()
        .map((b) => b.docs.map(Collocation.fromSnapshot).toList());
  }

  Future<List<Collocation>> getCollocations(String tabName) async {
    final collocations = _firestore
        .collection('Users')
        .doc(idOfsignedUser)
        .collection(tabName)
        .doc(selectedBook!.id)
        .collection('Collocations')
        .orderBy('Timestamp')
        .get();
    return (await collocations).docs.map(Collocation.fromSnapshot).toList();
  }

  Future<void> sendCollocation(String tabName, String text) async {
    _firestore
        .collection('Users')
        .doc(idOfsignedUser)
        .collection(tabName)
        .doc(selectedBook!.id)
        .collection('Collocations')
        .add(Collocation(id: null, content: text, timestamp: DateTime.now())
            .toMap());
  }

  Future<void> sendExistingCollocation(String tabName, String text) async {
    _firestore
        .collection('Users')
        .doc(idOfsignedUser)
        .collection(tabName)
        .doc(selectedBook!.id)
        .collection('Collocations')
        .doc(selectedCollocation!.id)
        .update({
      'Content': text,
      'Timestamp': selectedCollocation!.timestamp,
    });
  }

  Future<void> selectCollocation(Collocation collocation) async {
    selectedCollocation = collocation;
  }

  Future<void> deleteCollocation(String tabName, String id) async {
    _firestore
        .collection('Users')
        .doc(idOfsignedUser)
        .collection(tabName)
        .doc(selectedBook!.id)
        .collection('Collocations')
        .doc(id)
        .delete();
  }
}
