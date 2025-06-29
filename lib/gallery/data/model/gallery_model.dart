import 'package:cloud_firestore/cloud_firestore.dart';

class GalleryImage {
  final String? id;
  final String title;
  final String imageUrl;

  const GalleryImage({
    this.id,
    required this.title,
    required this.imageUrl,
  });

  /// Create a GalleryImage from Firestore document
  factory GalleryImage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GalleryImage(
      id: doc.id,
      title: data['title'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  /// Create a GalleryImage from a JSON map
  factory GalleryImage.fromJson(Map<String, dynamic> json) {
    return GalleryImage(
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  /// Convert to JSON (for Firestore or manual serialization)
  Map<String, dynamic> toJson() => {
        'title': title,
        'imageUrl': imageUrl,
      };

  /// Utility to clone and modify fields (useful after .add())
  GalleryImage copyWith({
    String? id,
    String? title,
    String? imageUrl,
  }) {
    return GalleryImage(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
