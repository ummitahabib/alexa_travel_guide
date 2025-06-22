class Event {
  final String title;
  final String description;
  final String date;
  final String location;
  final String imageUrl;

  const Event({
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.imageUrl,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'] as String,
      description: json['description'] as String,
      date: json['date'] as String,
      location: json['location'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'location': location,
      'imageUrl': imageUrl,
    };
  }
}
