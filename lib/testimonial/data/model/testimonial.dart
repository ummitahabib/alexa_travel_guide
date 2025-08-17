class Testimonial {
  final String id;
  final String name;
  final String region;
  final String comment;
  final double rating;

  Testimonial({
    required this.id,
    required this.name,
    required this.region,
    required this.comment,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'region': region,
      'comment': comment,
      'rating': rating,
    };
  }

  factory Testimonial.fromMap(String id, Map<String, dynamic> map) {
    return Testimonial(
      id: id,
      name: map['name'] ?? '',
      region: map['region'] ?? '',
      comment: map['comment'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
    );
  }
}
