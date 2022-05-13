import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  Book({
    required this.id,
    required this.author,
    required this.name,
    required this.timestamp,
    required this.imagePath,
    required this.category,
  });

  final String? id;
  final String author;
  final String name;
  final DateTime timestamp;
  final String imagePath;
  final String category;

  static Book fromSnapshot(
          QueryDocumentSnapshot<Map<String, dynamic>> snapshot) =>
      Book(
        id: snapshot.id,
        author: snapshot.data()['Author'],
        name: snapshot.data()['Name'],
        timestamp: (snapshot.data()['Timestamp'] as Timestamp).toDate(),
        imagePath: snapshot.data()['ImagePath'],
        category: snapshot.data()['Category'],
      );

  Map<String, dynamic> toMap() => {
        'Author': author,
        'Name': name,
        'Timestamp': Timestamp.fromDate(timestamp),
        'ImagePath': imagePath,
        'Category': category,
      };
}
