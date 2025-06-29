import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:she_travel/gallery/data/model/gallery_model.dart';
import 'package:she_travel/gallery/data/repository/gallery_repository.dart';

final galleryRepositoryProvider = Provider((ref) => GalleryRepository());

final galleryImagesProvider = FutureProvider<List<GalleryImage>>((ref) async {
  final repo = ref.watch(galleryRepositoryProvider);
  return await repo.fetchGalleryImages();
});
