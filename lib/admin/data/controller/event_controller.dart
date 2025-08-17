import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shetravels/admin/data/event_model.dart';
import 'package:shetravels/admin/data/event_repository/event_repository.dart';

final eventRepositoryProvider = Provider((ref) => EventRepository());

final upcomingEventsProvider = FutureProvider<List<Event>>((ref) async {
  final repo = ref.watch(eventRepositoryProvider);
  return await repo.fetchEvents();

});



