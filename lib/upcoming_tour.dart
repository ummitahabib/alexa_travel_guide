import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:she_travel/admin/data/controller/event_controller.dart';
import 'package:she_travel/admin/data/event_model.dart';

// class UpcomingTours extends StatefulWidget {
//   const UpcomingTours({Key? key}) : super(key: key);

//   @override
//   State<UpcomingTours> createState() => _UpcomingToursState();
// }

// class _UpcomingToursState extends State<UpcomingTours> {
//   List<Event> _events = [];

//   @override
//   void initState() {
//     super.initState();
//     loadEvents();
//   }

//   Future<void> loadEvents() async {
//     final String jsonString = await rootBundle.loadString('assets/data/local_events.json');
//     final List<dynamic> jsonResponse = json.decode(jsonString);
//     setState(() {
//       _events = jsonResponse.map((e) => Event.fromJson(e)).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.black,
//       padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             "Upcoming Events",
//             style: GoogleFonts.poppins(
//               fontSize: 35,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             "Curated faith-friendly adventures & soulful hikes.",
//             style: GoogleFonts.poppins(fontSize: 18, color: Colors.white70),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 30),
//           _events.isEmpty
//               ? CircularProgressIndicator(color: Colors.pink.shade100)
//               : Column(
//                   children: _events.map((event) {
//                     return Container(
//                       margin: const EdgeInsets.only(bottom: 30),
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         color: Colors.white,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Image.asset(
//                               event.imageUrl,
//                               width: double.infinity,
//                               height: 200,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           Text(
//                             event.title,
//                             style: GoogleFonts.poppins(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black87,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           Text(
//                             "${event.date} • ${event.location}",
//                             style: GoogleFonts.poppins(
//                               fontSize: 14,
//                               color: Colors.black54,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             event.description,
//                             style: GoogleFonts.poppins(fontSize: 14),
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//                 ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpcomingTours extends ConsumerWidget {
  const UpcomingTours({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(upcomingEventsProvider);

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Upcoming Events",
            style: GoogleFonts.poppins(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Curated faith-friendly adventures & soulful hikes.",
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          eventsAsync.when(
            loading:
                () => CircularProgressIndicator(color: Colors.pink.shade100),
            error:
                (e, _) =>
                    Text("Error: $e", style: TextStyle(color: Colors.red)),
            data:
                (events) =>
                    events.isEmpty
                        ? const Text(
                          "No upcoming events.",
                          style: TextStyle(color: Colors.white),
                        )
                        : Column(
                          children:
                              events.map((event) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 30),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          event.imageUrl,
                                          width: double.infinity,
                                          height: 200,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (_, __, ___) => Container(
                                                color: Colors.grey,
                                                height: 200,
                                                alignment: Alignment.center,
                                                child: const Icon(
                                                  Icons.broken_image,
                                                ),
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        event.title,
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "${event.date} • ${event.location}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        event.description,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                        ),
          ),
        ],
      ),
    );
  }
}
