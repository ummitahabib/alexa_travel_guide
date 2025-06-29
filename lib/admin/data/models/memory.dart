import 'package:cloud_firestore/cloud_firestore.dart';

// class Memory {
//   final String? id;
//   final String title;
//   final String description;
//   final String imageUrl;

//   Memory({
//     this.id,
//     required this.title,
//     required this.description,
//     required this.imageUrl,
//   });

//   factory Memory.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return Memory(
//       id: doc.id,
//       title: data['title'],
//       description: data['description'],
//       imageUrl: data['imageUrl'],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'title': title,
//         'description': description,
//         'imageUrl': imageUrl,
//       };
// }




import 'package:cloud_firestore/cloud_firestore.dart';

class Memory {
  final String? id;
  final String title;
  final String description;
  final String imageUrl;

  Memory({
    this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Memory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Memory(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
      };
}
