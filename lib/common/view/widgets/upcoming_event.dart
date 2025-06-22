import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildUpcomingEventsSection() {
  return Container(
    color: Colors.grey.shade100,
    width: double.infinity,
    padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
    child: Column(
      children: [
        Text(
          "Upcoming Events",
          style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          "Join us for soul-nourishing retreats, reflective walks, and in-person sisterhood experiences.",
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: 380,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: upcomingEvents.length,
            separatorBuilder: (_, __) => SizedBox(width: 16),
            padding: EdgeInsets.symmetric(horizontal: 8),
            itemBuilder: (context, index) {
              return _buildEventCard(upcomingEvents[index]);
            },
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink.shade200,
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          ),
          onPressed: () {
            // Navigate to all events page or booking calendar
          },
          child: Text("View All Events"),
        ),
      ],
    ),
  );
}

class Event {
  final String title;
  final String date;
  final String description;
  final String imageUrl;

  Event({
    required this.title,
    required this.date,
    required this.description,
    required this.imageUrl,
  });
}

final List<Event> upcomingEvents = [
  Event(
    title: "Wellness Reset",
    date: "1 June 2025 • 08:00–14:00",
    description:
        "A soul-nourishing retreat combining halaqa and hiking for inner renewal.",
    imageUrl: 'assets/image_1.webp',
  ),
  Event(
    title: "Dhikr Walk & Halaqah",
    date: "26 July 2025 • 07:00–12:00",
    description:
        "A reflective walk paired with spiritual discussion and sisterhood.",
    imageUrl: 'assets/image_6.webp',
  ),
  Event(
    title: "Hike  Retreat",
    date: "15–20 Aug 2025",
    description:
        "Five days of culture, reflection, and bonding in the heart of Arewa.",
    imageUrl: 'assets/image_11.webp',
  ),

    Event(
    title: "Wellness Reset",
    date: "1 June 2025 • 08:00–14:00",
    description:
        "A soul-nourishing retreat combining halaqa and hiking for inner renewal.",
    imageUrl: 'assets/image_3.webp',
  ),
  Event(
    title: "Dhikr Walk & Halaqah",
    date: "26 July 2025 • 07:00–12:00",
    description:
        "A reflective walk paired with spiritual discussion and sisterhood.",
    imageUrl: 'assets/past3.webp',
  ),

    Event(
    title: "Dhikr Walk & Halaqah",
    date: "26 July 2025 • 07:00–12:00",
    description:
        "A reflective walk paired with spiritual discussion and sisterhood.",
    imageUrl: 'assets/bali.webp',
  ),
];

Widget _buildEventCard(Event event) {
  return GestureDetector(
    onTap: () {
      // Navigate to details or booking page
    },
    child: Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
        ],
        image: DecorationImage(
          image: AssetImage(event.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.date,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event.title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event.description,
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                  onPressed: () {
                    // Navigate to details
                  },
                  child: Text("Read More"),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
