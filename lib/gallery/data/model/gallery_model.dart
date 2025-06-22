class GalleryImage {
  final String title;
  final String imageUrl;

  GalleryImage({required this.title, required this.imageUrl});

  factory GalleryImage.fromJson(Map<String, dynamic> json) {
    return GalleryImage(
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'imageUrl': imageUrl,
      };
}
