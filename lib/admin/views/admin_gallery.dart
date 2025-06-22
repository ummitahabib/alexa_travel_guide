import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:she_travel/gallery/data/model/gallery_model.dart';

@RoutePage()
class AdminGalleryScreen extends StatefulWidget {
  const AdminGalleryScreen({super.key});

  @override
  State<AdminGalleryScreen> createState() => _AdminGalleryScreenState();
}

class _AdminGalleryScreenState extends State<AdminGalleryScreen> {
  List<GalleryImage> gallery = [];

  final _titleController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadGallery();
  }

  Future<void> loadGallery() async {
    final jsonStr = await rootBundle.loadString('assets/data/gallery.json');
    final List<dynamic> data = json.decode(jsonStr);
    setState(() {
      gallery = data.map((e) => GalleryImage.fromJson(e)).toList();
    });
  }

  void _addImage() {
    if (_formKey.currentState!.validate()) {
      final newImg = GalleryImage(
        title: _titleController.text,
        imageUrl: _imageUrlController.text,
      );
      setState(() {
        gallery.add(newImg);
      });

      _titleController.clear();
      _imageUrlController.clear();
    }
  }

  void _deleteImage(int index) {
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
                    validator:
                        (value) => value!.isEmpty ? 'Enter a title' : null,
                  ),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(labelText: "Image Path"),
                    validator:
                        (value) => value!.isEmpty ? 'Enter image path' : null,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _addImage,
                    child: const Text("Add Image"),
                  ),
                ],
              ),
            ),
            const Divider(height: 32),
            const Text("Gallery List"),
            Expanded(
              child: ListView.builder(
                itemCount: gallery.length,
                itemBuilder: (context, index) {
                  final img = gallery[index];
                  return ListTile(
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
