import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:shetravels/testimonial/data/testimonial_repository.dart';

import '../data/model/testimonial.dart';

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

class TestimonialListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("What Travellers Say")),
      body: StreamBuilder<List<Testimonial>>(
        stream: TestimonialRepository.getTestimonialsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No testimonials yet."));
          }
          final testimonials = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: testimonials.length,
            itemBuilder: (context, index) {
              return buildTestimonialCard(testimonials[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_comment),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => Container()),
            //AddTestimonialPage()),
          );
        },
      ),
    );
  }
}
