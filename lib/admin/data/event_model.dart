import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String? id;
  final String title;
  final String date;
  final String description;
  final String imageUrl;
  final String location;

  Event({
    this.id,
    required this.title,
    required this.date,
    required this.description,
    required this.imageUrl,
    required this.location,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'],
      date: data['date'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      location: data['location'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'date': date,
        'description': description,
        'imageUrl': imageUrl,
        'location': location,
      };
}
