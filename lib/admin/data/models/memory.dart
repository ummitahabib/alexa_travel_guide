import 'package:cloud_firestore/cloud_firestore.dart';


class Memory {
  final String? id;
  final String title;
  final String description;
  final String imageUrl;
    final String location;
  final String category;
  final Timestamp createdAt;

  Memory({
    this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
        this.location = '',
    this.category = 'Adventure',
    required this.createdAt,
  });

  factory Memory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Memory(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
         location: data['location'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? 'Adventure',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
              'location': location,
      'category': category,
      'createdAt': createdAt,
      };
}

