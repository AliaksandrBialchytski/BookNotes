import 'package:cloud_firestore/cloud_firestore.dart';

class Collocation {
  Collocation(
      {required this.id, required this.content, required this.timestamp});

  final String? id;
  final String content;
  final DateTime timestamp;

  static Collocation fromSnapshot(
          QueryDocumentSnapshot<Map<String, dynamic>> snapshot) =>
      Collocation(
        id: snapshot.id,
        content: snapshot.data()['Content'],
        timestamp: (snapshot.data()['Timestamp'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toMap() => {
        'Content': content,
        'Timestamp': Timestamp.fromDate(timestamp),
      };
}
