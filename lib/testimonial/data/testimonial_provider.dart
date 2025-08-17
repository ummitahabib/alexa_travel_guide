import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shetravels/she_travel_web.dart';
import 'package:shetravels/testimonial/data/model/testimonial.dart';
import 'package:shetravels/testimonial/data/testimonial_repository.dart';

// State class for testimonials
class TestimonialState {
  final List<Testimonial> testimonials;
  final bool isLoading;
  final String? error;

  const TestimonialState({
    this.testimonials = const [],
    this.isLoading = false,
    this.error,
  });

  TestimonialState copyWith({
    List<Testimonial>? testimonials,
    bool? isLoading,
    String? error,
  }) {
    return TestimonialState(
      testimonials: testimonials ?? this.testimonials,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notifier class
class TestimonialNotifier extends StateNotifier<TestimonialState> {
  TestimonialNotifier() : super(const TestimonialState(isLoading: true)) {
    _loadTestimonials();
  }

  void _loadTestimonials() {
    TestimonialRepository.getTestimonialsStream().listen(
      (testimonials) {
        state = state.copyWith(
          testimonials: testimonials,
          isLoading: false,
          error: null,
        );
      },
      onError: (error) {
        state = state.copyWith(isLoading: false, error: error.toString());
      },
    );
  }

  Future<void> addTestimonial(Testimonial testimonial) async {
    try {
      await TestimonialRepository.addTestimonial(testimonial);
      // The stream will automatically update the state
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> removeTestimonial(String id) async {
    try {
      await TestimonialRepository.removeTestimonial(id);
      // The stream will automatically update the state
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Provider
final testimonialProvider =
    StateNotifierProvider<TestimonialNotifier, TestimonialState>(
      (ref) => TestimonialNotifier(),
    );

// Alternative: Using StreamProvider (simpler approach)
final testimonialsStreamProvider = StreamProvider<List<Testimonial>>((ref) {
  return TestimonialRepository.getTestimonialsStream();
});
