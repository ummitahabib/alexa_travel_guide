import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../data/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_io/io.dart';

// @RoutePage()
// class AdminPanelScreen extends StatefulWidget {
//   const AdminPanelScreen({super.key});

//   @override
//   State<AdminPanelScreen> createState() => _AdminPanelScreenState();
// }

// class _AdminPanelScreenState extends State<AdminPanelScreen> {
//   final _eventsRef = FirebaseFirestore.instance.collection('events');
//   List<Event> events = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadEvents();
//   }

//   Future<void> _loadEvents() async {
//     final snapshot = await _eventsRef.get();
//     final fetched =
//         snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
//     setState(() => events = fetched);
//   }

//   Future<void> _addEvent(Event event) async {
//     await _eventsRef.add(event.toJson());
//     _loadEvents(); // reload
//   }

//   Future<void> _removeEvent(String id) async {
//     await _eventsRef.doc(id).delete();
//     _loadEvents();
//   }

//   Future<String?> _uploadImageWeb(Uint8List bytes) async {
//     try {
//       final ref = FirebaseStorage.instance
//           .ref('events/${DateTime.now().millisecondsSinceEpoch}.jpg');
//       await ref.putData(bytes);
//       return await ref.getDownloadURL();
//     } catch (e) {
//       debugPrint('Image upload error (web): $e');
//       return null;
//     }
//   }

//   Future<String?> _uploadImageMobile(String path) async {
//     try {
//       final ref = FirebaseStorage.instance
//           .ref('events/${DateTime.now().millisecondsSinceEpoch}.jpg');
//       await ref.putFile(File(path));
//       return await ref.getDownloadURL();
//     } catch (e) {
//       debugPrint('Image upload error (mobile): $e');
//       return null;
//     }
//   }

//   void _showAddDialog() {
//     final titleController = TextEditingController();
//     final dateController = TextEditingController();
//     final descController = TextEditingController();
//     final locationController = TextEditingController();

//     String? imageUrl;
//     Uint8List? imageBytes;
//     String? imagePath;

//     showDialog(
//       context: context,
//       builder: (_) => StatefulBuilder(
//         builder: (context, setStateDialog) => AlertDialog(
//           title: const Text("Add New Event"),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextField(
//                   controller: titleController,
//                   decoration: const InputDecoration(labelText: "Title"),
//                 ),
//                 TextField(
//                   controller: dateController,
//                   decoration: const InputDecoration(labelText: "Date"),
//                 ),
//                 TextField(
//                   controller: descController,
//                   decoration: const InputDecoration(labelText: "Description"),
//                 ),
//                 TextField(
//                   controller: locationController,
//                   decoration: const InputDecoration(labelText: "Location"),
//                 ),
//                 const SizedBox(height: 10),
//                 if (imageBytes != null)
//                   Image.memory(imageBytes!, height: 120, fit: BoxFit.cover)
//                 else if (imagePath != null)
//                   Image.file(File(imagePath!), height: 120, fit: BoxFit.cover)
//                 else if (imageUrl != null)
//                   Image.network(imageUrl!, height: 120, fit: BoxFit.cover),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final picker = ImagePicker();
//                     if (kIsWeb) {
//                       final file = await picker.pickImage(source: ImageSource.gallery);
//                       if (file == null) return;
//                       final bytes = await file.readAsBytes();
//                       setStateDialog(() {
//                         imageBytes = bytes;
//                         imagePath = null;
//                         imageUrl = null;
//                       });
//                     } else {
//                       final file = await picker.pickImage(source: ImageSource.gallery);
//                       if (file == null) return;
//                       setStateDialog(() {
//                         imagePath = file.path;
//                         imageBytes = null;
//                         imageUrl = null;
//                       });
//                     }
//                   },
//                   child: const Text("Select Image"),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     if (kIsWeb && imageBytes != null) {
//                       final url = await _uploadImageWeb(imageBytes!);
//                       if (url != null) {
//                         setStateDialog(() => imageUrl = url);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("Image uploaded")),
//                         );
//                       }
//                     } else if (!kIsWeb && imagePath != null) {
//                       final url = await _uploadImageMobile(imagePath!);
//                       if (url != null) {
//                         setStateDialog(() => imageUrl = url);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("Image uploaded")),
//                         );
//                       }
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text("Please select an image first")),
//                       );
//                     }
//                   },
//                   child: const Text("Upload Image"),
//                 ),
//                 if (imageUrl != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text(
//                       "Image uploaded!",
//                       style: TextStyle(color: Colors.green),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//                 onPressed: () async {
//                 if (imageUrl == null) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Please upload an image")),
//                   );
//                   return;
//                 }

//                 try {
//                   final newEvent = Event(
//                   title: titleController.text,
//                   date: dateController.text,
//                   description: descController.text,
//                   imageUrl: imageUrl!,
//                   location: locationController.text,
//                   );
//                   await _addEvent(newEvent);
//                   Navigator.pop(context);
//                 } catch (e, stack) {
//                   debugPrint('Error adding event: $e');
//                   debugPrint('Stack trace: $stack');
//                   ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Failed to add event. See console for details.")),
//                   );
//                 }
//               },
//               child: const Text("Add"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Manage Events"),
//         actions: [
//           IconButton(icon: const Icon(Icons.refresh), onPressed: _loadEvents),
//           IconButton(icon: const Icon(Icons.add), onPressed: _showAddDialog),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: events.length,
//         itemBuilder: (_, index) {
//           final e = events[index];
//           return ListTile(
//             leading: CircleAvatar(backgroundImage: NetworkImage(e.imageUrl)),
//             title: Text(e.title),
//             subtitle: Text("${e.date} • ${e.location}"),
//             trailing: IconButton(
//               icon: const Icon(Icons.delete),
//               onPressed: () => _removeEvent(e.id!),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


@RoutePage()
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final _eventsRef = FirebaseFirestore.instance.collection('events');
  final _auth = FirebaseAuth.instance;
  List<Event> events = [];
  bool _isLoading = false;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _checkAuthAndLoadEvents();
  }

  Future<void> _checkAuthAndLoadEvents() async {
    setState(() => _isLoading = true);
    
    // Check if user is authenticated
    _currentUser = _auth.currentUser;
    
    if (_currentUser == null) {
      // Sign in anonymously or show login dialog
      await _signInUser();
    }
    
    if (_currentUser != null) {
      await _loadEvents();
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _signInUser() async {
    try {
      // For testing: sign in anonymously
      final userCredential = await _auth.signInAnonymously();
      _currentUser = userCredential.user;
      
      // Alternatively, you can use email/password sign in:
      // final userCredential = await _auth.signInWithEmailAndPassword(
      //   email: 'admin@example.com',
      //   password: 'your_password',
      // );
      
      debugPrint('Signed in user: ${_currentUser?.uid}');
    } catch (e) {
      debugPrint('Sign in error: $e');
      _showErrorSnackBar('Authentication failed: $e');
    }
  }

  Future<void> _loadEvents() async {
    if (_currentUser == null) return;
    
    try {
      setState(() => _isLoading = true);
      final snapshot = await _eventsRef.get();
      final fetched = snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
      setState(() => events = fetched);
    } catch (e) {
      debugPrint('Load events error: $e');
      _showErrorSnackBar('Failed to load events: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addEvent(Event event) async {
    if (_currentUser == null) {
      _showErrorSnackBar('Please authenticate first');
      return;
    }
    
    try {
      await _eventsRef.add(event.toJson());
      await _loadEvents();
      _showSuccessSnackBar('Event added successfully');
    } catch (e) {
      debugPrint('Add event error: $e');
      _showErrorSnackBar('Failed to add event: $e');
    }
  }

  Future<void> _removeEvent(String id) async {
    if (_currentUser == null) {
      _showErrorSnackBar('Please authenticate first');
      return;
    }
    
    try {
      await _eventsRef.doc(id).delete();
      await _loadEvents();
      _showSuccessSnackBar('Event deleted successfully');
    } catch (e) {
      debugPrint('Remove event error: $e');
      _showErrorSnackBar('Failed to remove event: $e');
    }
  }

  Future<String?> _uploadImage({Uint8List? bytes, String? filePath}) async {
    if (_currentUser == null) {
      _showErrorSnackBar('Please authenticate first');
      return null;
    }
    
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ref = FirebaseStorage.instance.ref('events/$timestamp.jpg');

      UploadTask uploadTask;
      
      if (kIsWeb && bytes != null) {
        // For web, use putData with metadata
        final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'uploadedBy': _currentUser!.uid,
          },
        );
        uploadTask = ref.putData(bytes, metadata);
      } else if (!kIsWeb && filePath != null) {
        // For mobile, use putFile
        final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'uploadedBy': _currentUser!.uid,
          },
        );
        uploadTask = ref.putFile(File(filePath), metadata);
      } else {
        throw Exception("Invalid image data provided");
      }

      // Wait for upload to complete
      final snapshot = await uploadTask;
      
      // Get download URL
      final downloadURL = await snapshot.ref.getDownloadURL();
      debugPrint('Image uploaded successfully: $downloadURL');
      
      return downloadURL;
    } catch (e) {
      debugPrint('Image upload error: $e');
      _showErrorSnackBar('Image upload failed: $e');
      return null;
    }
  }

  void _showAddDialog() {
    final titleController = TextEditingController();
    final dateController = TextEditingController();
    final descController = TextEditingController();
    final locationController = TextEditingController();

    Uint8List? imageBytes;
    String? imagePath;
    String? imageUrl;
    bool isUploading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text("Add New Event"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: "Date",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: "Location",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                
                // Image preview
                if (imageBytes != null)
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(imageBytes!, fit: BoxFit.cover),
                    ),
                  )
                else if (imagePath != null)
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(File(imagePath!), fit: BoxFit.cover),
                    ),
                  )
                else if (imageUrl != null)
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.error),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[300],
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                
                const SizedBox(height: 10),
                
                // Image selection and upload buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isUploading ? null : () async {
                          final picker = ImagePicker();
                          final picked = await picker.pickImage(
                            source: ImageSource.gallery,
                            maxWidth: 1024,
                            maxHeight: 1024,
                            imageQuality: 85,
                          );
                          
                          if (picked == null) return;

                          if (kIsWeb) {
                            final bytes = await picked.readAsBytes();
                            setStateDialog(() {
                              imageBytes = bytes;
                              imagePath = null;
                              imageUrl = null;
                            });
                          } else {
                            setStateDialog(() {
                              imagePath = picked.path;
                              imageBytes = null;
                              imageUrl = null;
                            });
                          }
                        },
                        icon: const Icon(Icons.photo_library),
                        label: const Text("Select"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isUploading || 
                                   (imageBytes == null && imagePath == null) 
                          ? null 
                          : () async {
                            setStateDialog(() => isUploading = true);
                            
                            final uploadedUrl = await _uploadImage(
                              bytes: imageBytes,
                              filePath: imagePath,
                            );

                            setStateDialog(() {
                              isUploading = false;
                              if (uploadedUrl != null) {
                                imageUrl = uploadedUrl;
                                imageBytes = null;
                                imagePath = null;
                              }
                            });
                          },
                        icon: isUploading 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.cloud_upload),
                        label: Text(isUploading ? "Uploading..." : "Upload"),
                      ),
                    ),
                  ],
                ),
                
                if (imageUrl != null)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        SizedBox(width: 4),
                        Text("Image uploaded!", style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: isUploading ? null : () async {
                // Validation
                if (titleController.text.trim().isEmpty) {
                  _showErrorSnackBar("Please enter a title");
                  return;
                }
                if (imageUrl == null) {
                  _showErrorSnackBar("Please upload an image");
                  return;
                }

                final newEvent = Event(
                  title: titleController.text.trim(),
                  date: dateController.text.trim(),
                  description: descController.text.trim(),
                  location: locationController.text.trim(),
                  imageUrl: imageUrl!,
                );

                Navigator.pop(context);
                await _addEvent(newEvent);
              },
              child: const Text("Add Event"),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Events"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadEvents,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _currentUser == null || _isLoading ? null : _showAddDialog,
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'logout') {
                await _auth.signOut();
                setState(() {
                  _currentUser = null;
                  events = [];
                });
                _showSuccessSnackBar('Signed out successfully');
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    const Icon(Icons.logout),
                    const SizedBox(width: 8),
                    Text('Sign Out (${_currentUser?.uid?.substring(0, 8) ?? 'N/A'})'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentUser == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('Please authenticate to continue'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _checkAuthAndLoadEvents,
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),
                )
              : events.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_note, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No events yet'),
                          SizedBox(height: 8),
                          Text('Tap the + button to add your first event'),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadEvents,
                      child: ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (_, index) {
                          final event = events[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey[300],
                                child: ClipOval(
                                  child: Image.network(
                                    event.imageUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.event, size: 30);
                                    },
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const CircularProgressIndicator(strokeWidth: 2);
                                    },
                                  ),
                                ),
                              ),
                              title: Text(
                                event.title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text("📅 ${event.date}"),
                                  Text("📍 ${event.location}"),
                                  if (event.description.isNotEmpty)
                                    Text(
                                      event.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _showDeleteConfirmation(event),
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
                    ),
    );
  }

  void _showDeleteConfirmation(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _removeEvent(event.id!);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
