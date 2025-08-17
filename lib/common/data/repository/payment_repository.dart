// lib/repositories/payment_repository.dart
import 'dart:convert';
import 'dart:html' as html; // For web redirection
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(FirebaseAuth.instance, FirebaseFirestore.instance);
});

class PaymentRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  PaymentRepository(this._auth, this._firestore);

  Future<void> handlePayment({
    required int amount,
    required String eventName,
  }) async {
    final user = _auth.currentUser;

    if (kIsWeb) {
      // 🔁 Web checkout flow
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
        if (user != null) {
          await _firestore.collection('bookings').add({
            'userId': user.uid,
            'eventName': eventName,
            'amount': amount,
            'timestamp': FieldValue.serverTimestamp(),
            'status': 'pending',
            'platform': 'web',
          });
        }
        html.window.location.href = checkoutUrl;
      }
    } else {
      // 📱 Mobile (Payment Sheet)
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

      if (user != null) {
        await _firestore.collection('bookings').add({
          'userId': user.uid,
          'eventName': eventName,
          'amount': amount,
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'paid',
          'platform': 'mobile',
        });
      }
    }
  }

  Future<bool> hasUserBookedEvent(String userId, String eventName) async {
    try {
      final bookings =
          await _firestore
              .collection('bookings')
              .where('userId', isEqualTo: userId)
              .where('eventName', isEqualTo: eventName)
              .where('status', whereIn: ['paid', 'pending'])
              .get();
      return bookings.docs.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking booking status: $e');
      return false;
    }
  }

  Map<String, int> calculateCountdown(String dateString) {
    try {
      final eventDate = DateTime.tryParse(dateString);
      if (eventDate == null) {
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
    } catch (_) {
      return {'days': 0, 'hours': 0, 'minutes': 0};
    }
  }
}
