import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shetravels/gallery/data/model/gallery_model.dart';

class GalleryRepository {
  final _galleryRef = FirebaseFirestore.instance.collection('gallery');

  Future<List<GalleryImage>> fetchGalleryImages() async {
    final snapshot = await _galleryRef.get();
    return snapshot.docs.map((doc) => GalleryImage.fromFirestore(doc)).toList();
  }
}
