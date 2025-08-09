import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shetravels/admin/data/controller/event_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:shetravels/auth/views/screens/login_screen.dart';



class UpcomingTours extends ConsumerWidget {
  const UpcomingTours({Key? key}) : super(key: key);

  Future<void> _handlePayment({
    required BuildContext context,
    required int amount,
    required String eventName,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (kIsWeb) {
        // 🔁 Use Stripe Checkout for Web
        final url = Uri.parse(
          'https://us-central1-shetravels-ac34a.cloudfunctions.net/createCheckoutSession',
        );

        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'amount': amount, 'currency': 'usd'}),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to create checkout session');
        }

        final jsonResponse = json.decode(response.body);
        final checkoutUrl = jsonResponse['checkoutUrl'];

        if (checkoutUrl != null) {
          // ✅ Optional: Save "pending" booking before redirect
          if (user != null) {
            await FirebaseFirestore.instance.collection('bookings').add({
              'userId': user.uid,
              'eventName': eventName,
              'amount': amount,
              'timestamp': FieldValue.serverTimestamp(),
              'status': 'pending',
              'platform': 'web',
            });
          }

          html.window.location.href = checkoutUrl; // 🚀 Redirect to Stripe
        }
      } else {
        // 📱 Mobile (iOS/Android) — Payment Sheet
        final url = Uri.parse(
          'https://us-central1-shetravels-ac34a.cloudfunctions.net/createPaymentIntent',
        );

        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'amount': amount, 'currency': 'usd'}),
        );

        if (response.statusCode != 200) {
          throw Exception('Failed to create payment intent');
        }

        final jsonResponse = json.decode(response.body);
        final clientSecret = jsonResponse['clientSecret'];

        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: eventName,
          ),
        );

        await Stripe.instance.presentPaymentSheet();

        // ✅ Save booking on successful payment
        if (user != null) {
          await FirebaseFirestore.instance.collection('bookings').add({
            'userId': user.uid,
            'eventName': eventName,
            'amount': amount,
            'timestamp': FieldValue.serverTimestamp(),
            'status': 'paid',
            'platform': 'mobile',
          });
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Payment successful')));
      }
    } catch (e) {
      print('Payment error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment Error: $e')));
    }
  }

  // Check if user has already booked this event
  Future<bool> _hasUserBookedEvent(String userId, String eventName) async {
    try {
      final bookings = await FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .where('eventName', isEqualTo: eventName)
          .where('status', whereIn: ['paid', 'pending'])
          .get();
      
      return bookings.docs.isNotEmpty;
    } catch (e) {
      print('Error checking booking status: $e');
      return false;
    }
  }

  // Parse date string and calculate countdown
  Map<String, int> _calculateCountdown(String dateString) {
    try {
      // Assuming date format is "MMM dd, yyyy" or similar
      // You might need to adjust this parsing based on your actual date format
      final eventDate = DateTime.tryParse(dateString);
      if (eventDate == null) {
        // Try alternative parsing if needed
        return {'days': 0, 'hours': 0, 'minutes': 0};
      }

      final now = DateTime.now();
      final difference = eventDate.difference(now);
      
      if (difference.isNegative) {
        return {'days': 0, 'hours': 0, 'minutes': 0};
      }

      return {
        'days': difference.inDays,
        'hours': difference.inHours % 24,
        'minutes': difference.inMinutes % 60,
      };
    } catch (e) {
      return {'days': 0, 'hours': 0, 'minutes': 0};
    }
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String userId,
    required dynamic event,
  }) {
    return FutureBuilder<bool>(
      future: _hasUserBookedEvent(userId, event.title),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 40,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        final hasBooked = snapshot.data ?? false;

        if (hasBooked) {
          // Show countdown if user has booked
          final countdown = _calculateCountdown(event.date);
          final days = countdown['days'] ?? 0;
          final hours = countdown['hours'] ?? 0;
          final minutes = countdown['minutes'] ?? 0;

          if (days <= 0 && hours <= 0 && minutes <= 0) {
            // Event has passed or is happening now
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Event Completed",
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade700,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      "Booked",
                      style: GoogleFonts.poppins(
                        color: Colors.green.shade600,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "${days}d ${hours}h ${minutes}m",
                  style: GoogleFonts.poppins(
                    color: Colors.green.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "until event",
                  style: GoogleFonts.poppins(
                    color: Colors.green.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }

        // Show book button if not booked
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink.shade100,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
          child: Text(
            "Book Now",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () async {
            await _handlePayment(
              context: context,
              amount: event.price,
              eventName: event.title,
            );
          },
        );
      },
    );
  }

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
            loading: () => CircularProgressIndicator(color: Colors.pink.shade100),
            error: (e, _) => Text("Error: $e", style: TextStyle(color: Colors.red)),
            data: (events) => events.isEmpty
                ? const Text(
                    "No upcoming events.",
                    style: TextStyle(color: Colors.white),
                  )
                : Column(
                    children: events.map((event) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                event.imageUrl,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey,
                                  height: 200,
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.broken_image),
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
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "\$${(event.price / 100).toStringAsFixed(2)}",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 15),
                            // Dynamic action button based on user authentication and booking status
                            Consumer(
                              builder: (context, ref, child) {
                                final user = FirebaseAuth.instance.currentUser;
                                
                                if (user == null) {
                                  // User not logged in - show login button
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.pink.shade100,
                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                    ),
                                    child: Text(
                                      "Login to Book",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onPressed: () async {
                                      final shouldContinue = await Navigator.push<bool>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const LoginScreen(),
                                        ),
                                      );
                                      
                                      if (shouldContinue == true && 
                                          FirebaseAuth.instance.currentUser != null) {
                                        // Trigger a rebuild to show the correct button state
                                        // The Consumer will automatically rebuild when auth state changes
                                      }
                                    },
                                  );
                                }
                                
                                // User is logged in - show appropriate button
                                return _buildActionButton(
                                  context: context,
                                  userId: user.uid,
                                  event: event,
                                );
                              },
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