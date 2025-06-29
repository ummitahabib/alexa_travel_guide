import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:she_travel/admin/data/event_model.dart';

class EventRepository {
  final _eventsRef = FirebaseFirestore.instance.collection('events');

  Future<List<Event>> fetchEvents() async {
    final snapshot = await _eventsRef.orderBy('date').get();
    return snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
  }
}
