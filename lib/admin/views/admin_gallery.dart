import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:she_travel/gallery/data/model/gallery_model.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


@RoutePage()


class AdminGalleryScreen extends StatefulWidget {
  const AdminGalleryScreen({super.key});

  @override
  State<AdminGalleryScreen> createState() => _AdminGalleryScreenState();
}

class _AdminGalleryScreenState extends State<AdminGalleryScreen> {
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<GalleryImage> gallery = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadGallery();
  }

  Future<void> _loadGallery() async {
    final snapshot = await FirebaseFirestore.instance.collection('gallery').get();
    final items = snapshot.docs.map((doc) => GalleryImage.fromFirestore(doc)).toList();
    setState(() {
      gallery = items;
    });
  }

  Future<String?> _pickAndUploadImage() async {
    try {
      if (kIsWeb) {
        final result = await FilePicker.platform.pickFiles(type: FileType.image);
        if (result != null && result.files.single.bytes != null) {
          final file = result.files.single;
          final ref = FirebaseStorage.instance.ref().child('gallery/${file.name}');
          await ref.putData(file.bytes!);
          return await ref.getDownloadURL();
        }
      } else {
        final picker = ImagePicker();
        final picked = await picker.pickImage(source: ImageSource.gallery);
        if (picked != null) {
          final ref = FirebaseStorage.instance.ref().child('gallery/${picked.name}');
          await ref.putFile(File(picked.path));
          return await ref.getDownloadURL();
        }
      }
    } catch (e) {
      debugPrint('Image upload failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed. Try again.')),
      );
    }
    return null;
  }

  Future<void> _addImage() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUploading = true);

    final imageUrl = await _pickAndUploadImage();
    if (imageUrl == null) {
      setState(() => _isUploading = false);
      return;
    }

    final newImg = GalleryImage(title: _titleController.text, imageUrl: imageUrl);
    final docRef = await FirebaseFirestore.instance.collection('gallery').add(newImg.toJson());

    setState(() {
      gallery.add(newImg.copyWith(id: docRef.id));
      _titleController.clear();
      _isUploading = false;
    });
  }

  Future<void> _deleteImage(int index) async {
    final img = gallery[index];
    await FirebaseFirestore.instance.collection('gallery').doc(img.id).delete();
    setState(() {
      gallery.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Gallery")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: "Title"),
                    validator: (val) => val!.isEmpty ? 'Enter a title' : null,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _isUploading ? null : _addImage,
                    icon: Icon(Icons.upload),
                    label: Text(_isUploading ? "Uploading..." : "Add Image"),
                  ),
                ],
              ),
            ),
            const Divider(height: 32),
            const Text("Gallery List", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Expanded(
              child: gallery.isEmpty
                  ? const Center(child: Text("No images yet."))
                  : ListView.builder(
                      itemCount: gallery.length,
                      itemBuilder: (context, index) {
                        final img = gallery[index];
                        return ListTile(
                          leading: Image.network(img.imageUrl, width: 60, fit: BoxFit.cover),
                          title: Text(img.title),
                          subtitle: Text(img.imageUrl),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteImage(index),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
