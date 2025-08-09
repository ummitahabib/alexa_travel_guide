import 'package:flutter/material.dart';
import 'package:shetravels/she_travel_web.dart';

Widget buildTestimonialCard(Testimonial t) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 3,
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    child: Container(
      width: 300,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.comment,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 12),
          Text(
            "- ${t.name}, ${t.region}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Row(
            children:
                List.generate(
                  t.rating.floor(),
                  (index) => Icon(Icons.star, color: Colors.amber, size: 18),
                ) +
                List.generate(
                  5 - t.rating.floor(),
                  (index) =>
                      Icon(Icons.star_border, color: Colors.grey, size: 18),
                ),
          ),
        ],
      ),
    ),
  );
}

Widget buildTestimonialSection(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          "What Travellers Say",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      SizedBox(
        height: 500,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: testimonials.length,
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            return buildTestimonialCard(testimonials[index]);
          },
        ),
      ),
    ],
  );
}
