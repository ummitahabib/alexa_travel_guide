import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../data/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_io/io.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:typed_data';

@RoutePage()
class AdminManageEventScreen extends StatefulWidget {
  const AdminManageEventScreen({super.key});

  @override
  State<AdminManageEventScreen> createState() => _AdminManageEventScreenState();
}

class _AdminManageEventScreenState extends State<AdminManageEventScreen>
    with TickerProviderStateMixin {
  final _eventsRef = FirebaseFirestore.instance.collection('events');
  final _auth = FirebaseAuth.instance;
  List<Event> events = [];
  bool _isLoading = false;
  User? _currentUser;
  late AnimationController _fabAnimationController;
  late AnimationController _headerAnimationController;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _checkAuthAndLoadEvents();
    _headerAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthAndLoadEvents() async {
    setState(() => _isLoading = true);

    _currentUser = _auth.currentUser;

    if (_currentUser == null) {
      await _signInUser();
    }

    if (_currentUser != null) {
      await _loadEvents();
    }

    setState(() => _isLoading = false);
  }

  Future<void> _signInUser() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      _currentUser = userCredential.user;
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
      final fetched =
          snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
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
        final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'uploadedBy': _currentUser!.uid},
        );
        uploadTask = ref.putData(bytes, metadata);
      } else if (!kIsWeb && filePath != null) {
        final metadata = SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'uploadedBy': _currentUser!.uid},
        );
        uploadTask = ref.putFile(File(filePath), metadata);
      } else {
        throw Exception("Invalid image data provided");
      }

      final snapshot = await uploadTask;
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
    final priceController = TextEditingController();

    Uint8List? imageBytes;
    String? imagePath;
    String? imageUrl;
    bool isUploading = false;

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder:
              (context, setStateDialog) => AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: animation.value,
                    child: Dialog(
                      backgroundColor: Colors.transparent,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.9,
                          maxHeight: MediaQuery.of(context).size.height * 0.85,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.white, Colors.purple.shade50],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.3),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Column(
                            children: [
                              // Header
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.purple.shade600,
                                      Colors.deepPurple.shade700,
                                    ],
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.event_available,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Expanded(
                                      child: Text(
                                        "Create New Event",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Content
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Title Field
                                      _buildModernTextField(
                                        controller: titleController,
                                        label: "Event Title",
                                        icon: Icons.title,
                                        hint: "Enter event name",
                                      ),

                                      const SizedBox(height: 20),

                                      // Date Field
                                      _buildModernTextField(
                                        controller: dateController,
                                        label: "Event Date",
                                        icon: Icons.calendar_today,
                                        hint: "Select date",
                                      ),

                                      const SizedBox(height: 20),

                                      // Location Field
                                      _buildModernTextField(
                                        controller: locationController,
                                        label: "Location",
                                        icon: Icons.location_on,
                                        hint: "Event venue",
                                      ),

                                      const SizedBox(height: 20),

                                      // Price Field
                                      _buildModernTextField(
                                        controller: priceController,
                                        label: "Price (USD)",
                                        icon: Icons.attach_money,
                                        hint: "0.00",
                                        keyboardType: TextInputType.number,
                                      ),

                                      const SizedBox(height: 20),

                                      // Description Field
                                      _buildModernTextField(
                                        controller: descController,
                                        label: "Description",
                                        icon: Icons.description,
                                        hint: "Event details",
                                        maxLines: 3,
                                      ),

                                      const SizedBox(height: 24),

                                      // Image Upload Section
                                      Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.blue.shade50,
                                              Colors.purple.shade50,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          border: Border.all(
                                            color: Colors.purple.shade200,
                                            width: 2,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Event Image",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.purple.shade700,
                                              ),
                                            ),

                                            const SizedBox(height: 16),

                                            // Image Preview
                                            _buildImagePreview(
                                              imageBytes,
                                              imagePath,
                                              imageUrl,
                                            ),

                                            const SizedBox(height: 16),

                                            // Upload Buttons
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: _buildModernButton(
                                                    onPressed:
                                                        isUploading
                                                            ? null
                                                            : () async {
                                                              final picker =
                                                                  ImagePicker();
                                                              final picked = await picker
                                                                  .pickImage(
                                                                    source:
                                                                        ImageSource
                                                                            .gallery,
                                                                    maxWidth:
                                                                        1024,
                                                                    maxHeight:
                                                                        1024,
                                                                    imageQuality:
                                                                        85,
                                                                  );

                                                              if (picked ==
                                                                  null)
                                                                return;

                                                              if (kIsWeb) {
                                                                final bytes =
                                                                    await picked
                                                                        .readAsBytes();
                                                                setStateDialog(
                                                                  () {
                                                                    imageBytes =
                                                                        bytes;
                                                                    imagePath =
                                                                        null;
                                                                    imageUrl =
                                                                        null;
                                                                  },
                                                                );
                                                              } else {
                                                                setStateDialog(
                                                                  () {
                                                                    imagePath =
                                                                        picked
                                                                            .path;
                                                                    imageBytes =
                                                                        null;
                                                                    imageUrl =
                                                                        null;
                                                                  },
                                                                );
                                                              }
                                                            },
                                                    icon: Icons.photo_library,
                                                    label: "Select",
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: _buildModernButton(
                                                    onPressed:
                                                        isUploading ||
                                                                (imageBytes ==
                                                                        null &&
                                                                    imagePath ==
                                                                        null)
                                                            ? null
                                                            : () async {
                                                              setStateDialog(
                                                                () =>
                                                                    isUploading =
                                                                        true,
                                                              );

                                                              final uploadedUrl =
                                                                  await _uploadImage(
                                                                    bytes:
                                                                        imageBytes,
                                                                    filePath:
                                                                        imagePath,
                                                                  );

                                                              setStateDialog(() {
                                                                isUploading =
                                                                    false;
                                                                if (uploadedUrl !=
                                                                    null) {
                                                                  imageUrl =
                                                                      uploadedUrl;
                                                                  imageBytes =
                                                                      null;
                                                                  imagePath =
                                                                      null;
                                                                }
                                                              });
                                                            },
                                                    icon:
                                                        isUploading
                                                            ? null
                                                            : Icons
                                                                .cloud_upload,
                                                    label:
                                                        isUploading
                                                            ? "Uploading..."
                                                            : "Upload",
                                                    color: Colors.purple,
                                                    isLoading: isUploading,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            if (imageUrl != null)
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  top: 12,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.green.shade100,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.check_circle,
                                                      color:
                                                          Colors.green.shade600,
                                                      size: 18,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      "Image uploaded successfully!",
                                                      style: TextStyle(
                                                        color:
                                                            Colors
                                                                .green
                                                                .shade700,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 32),

                                      // Action Buttons
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed:
                                                  () => Navigator.pop(context),
                                              style: OutlinedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 16,
                                                    ),
                                                side: BorderSide(
                                                  color: Colors.grey.shade400,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: const Text(
                                                "Cancel",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.purple.shade600,
                                                    Colors.deepPurple.shade700,
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.purple
                                                        .withOpacity(0.4),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: ElevatedButton(
                                                onPressed:
                                                    isUploading
                                                        ? null
                                                        : () async {
                                                          if (titleController
                                                              .text
                                                              .trim()
                                                              .isEmpty) {
                                                            _showErrorSnackBar(
                                                              "Please enter a title",
                                                            );
                                                            return;
                                                          }
                                                          if (imageUrl ==
                                                              null) {
                                                            _showErrorSnackBar(
                                                              "Please upload an image",
                                                            );
                                                            return;
                                                          }

                                                          final priceText =
                                                              priceController
                                                                  .text
                                                                  .trim();
                                                          if (priceText
                                                                  .isEmpty ||
                                                              double.tryParse(
                                                                    priceText,
                                                                  ) ==
                                                                  null) {
                                                            _showErrorSnackBar(
                                                              "Please enter a valid price",
                                                            );
                                                            return;
                                                          }

                                                          final priceInCents =
                                                              (double.parse(
                                                                        priceText,
                                                                      ) *
                                                                      100)
                                                                  .toInt();

                                                          final newEvent = Event(
                                                            title:
                                                                titleController
                                                                    .text
                                                                    .trim(),
                                                            date:
                                                                dateController
                                                                    .text
                                                                    .trim(),
                                                            description:
                                                                descController
                                                                    .text
                                                                    .trim(),
                                                            location:
                                                                locationController
                                                                    .text
                                                                    .trim(),
                                                            price: priceInCents,
                                                            imageUrl: imageUrl!,
                                                          );

                                                          Navigator.pop(
                                                            context,
                                                          );
                                                          await _addEvent(
                                                            newEvent,
                                                          );
                                                        },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  shadowColor:
                                                      Colors.transparent,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 16,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Create Event",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
        );
      },
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.purple.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, color: Colors.purple.shade400),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.purple.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.purple.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.purple.shade400, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(
    Uint8List? imageBytes,
    String? imagePath,
    String? imageUrl,
  ) {
    Widget imageWidget;

    if (imageBytes != null) {
      imageWidget = Image.memory(imageBytes, fit: BoxFit.cover);
    } else if (imagePath != null) {
      imageWidget = Image.file(File(imagePath), fit: BoxFit.cover);
    } else if (imageUrl != null) {
      imageWidget = Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade200,
            child: const Icon(Icons.error, color: Colors.grey),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey.shade200,
            child: Center(
              child: CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                color: Colors.purple,
              ),
            ),
          );
        },
      );
    } else {
      imageWidget = Container(
        color: Colors.grey.shade100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              "No image selected",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: imageWidget,
      ),
    );
  }

  Widget _buildModernButton({
    required VoidCallback? onPressed,
    IconData? icon,
    required String label,
    required Color color,
    bool isLoading = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon:
            isLoading
                ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : Icon(icon, color: Colors.white, size: 18),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final isMobile = MediaQuery.of(context).size.width < 500;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple.shade50, Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom Header
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -1),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _headerAnimationController,
                    curve: Curves.easeOutBack,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple.shade600,
                        Colors.deepPurple.shade700,
                        Colors.indigo.shade800,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.event_available,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Event Manager",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isMobile ? 20 : 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Manage your events with style",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: isMobile ? 12 : 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                  ),
                                  onPressed: _isLoading ? null : _loadEvents,
                                ),
                              ),
                              const SizedBox(width: 8),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  onPressed: _isLoading ? null : _showAddDialog,
                                ),
                              ),
                            
                              // PopupMenuButton<String>(
                              //   icon: Container(
                              //     padding: const EdgeInsets.all(8),
                              //     decoration: BoxDecoration(
                              //       color: Colors.white.withOpacity(0.1),
                              //       borderRadius: BorderRadius.circular(12),
                              //     ),
                              //     child: const Icon(
                              //       Icons.add,
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              //   onSelected: (value) async {
                              //     if (value == 'logout') {
                              //       await _auth.signOut();
                              //       setState(() {
                              //         _currentUser = null;
                              //         events = [];
                              //       });
                              //       _showSuccessSnackBar(
                              //         'Signed out successfully',
                              //       );
                              //     }
                              //   },
                              //   itemBuilder:
                              //       (context) => [
                              //         PopupMenuItem(
                              //           value: 'logout',
                              //           child: Row(
                              //             children: [
                              //               const Icon(Icons.logout),
                              //               const SizedBox(width: 8),
                              //               Text(
                              //                 'Sign Out (${_currentUser?.uid?.substring(0, 8) ?? 'N/A'})',
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ],
                              // ),
                          
                          
                            ],
                          ),
                        ],
                      ),

                      if (!isMobile) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _buildStatCard(
                              "Total Events",
                              "${events.length}",
                              Icons.event,
                              Colors.orange,
                            ),
                            const SizedBox(width: 16),
                            _buildStatCard(
                              "Active",
                              "${events.length}",
                              Icons.play_circle,
                              Colors.green,
                            ),
                            const SizedBox(width: 16),
                            _buildStatCard(
                              "This Month",
                              "0",
                              Icons.calendar_month,
                              Colors.blue,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Body Content
              Expanded(
                child:
                    _isLoading
                        ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.purple,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Loading events...",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                        : _currentUser == null
                        ? Center(
                          child: Container(
                            margin: const EdgeInsets.all(32),
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple.withOpacity(0.1),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.purple.shade100,
                                        Colors.blue.shade100,
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.lock,
                                    size: 48,
                                    color: Colors.purple,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'Authentication Required',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Please sign in to manage events',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.purple.shade600,
                                        Colors.deepPurple.shade700,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.purple.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: _checkAuthAndLoadEvents,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.login,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'Sign In',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        : events.isEmpty
                        ? Center(
                          child: Container(
                            margin: const EdgeInsets.all(32),
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.orange.shade100,
                                        Colors.pink.shade100,
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.event_note,
                                    size: 48,
                                    color: Colors.orange,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  'No Events Yet',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Start by creating your first amazing event',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.orange.shade400,
                                        Colors.pink.shade500,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: _showAddDialog,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'Create First Event',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        : RefreshIndicator(
                          onRefresh: _loadEvents,
                          color: Colors.purple,
                          child: Padding(
                            padding: EdgeInsets.all(isMobile ? 16 : 24),
                            child:
                                isTablet
                                    ? GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 16,
                                            mainAxisSpacing: 16,
                                            childAspectRatio: 1.2,
                                          ),
                                      itemCount: events.length,
                                      itemBuilder:
                                          (context, index) => _buildEventCard(
                                            events[index],
                                            index,
                                          ),
                                    )
                                    : ListView.builder(
                                      itemCount: events.length,
                                      itemBuilder:
                                          (context, index) => _buildEventCard(
                                            events[index],
                                            index,
                                          ),
                                    ),
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButton:
          _currentUser != null && !_isLoading
              ? ScaleTransition(
                scale: CurvedAnimation(
                  parent: _fabAnimationController,
                  curve: Curves.elasticOut,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple.shade400,
                        Colors.deepPurple.shade600,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      _fabAnimationController.reverse().then((_) {
                        _showAddDialog();
                        _fabAnimationController.forward();
                      });
                    },
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      "New Event",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
              : null,
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(Event event, int index) {
    final isMobile = MediaQuery.of(context).size.width < 500;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutBack,
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.purple.shade50.withOpacity(0.5)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Event Image
                Container(
                  width: isMobile ? 80 : 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple.shade200, Colors.blue.shade200],
                    ),
                  ),
                  child: ClipRRect(
                    child: Image.network(
                      event.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.purple.shade100,
                          child: const Icon(
                            Icons.event,
                            size: 40,
                            color: Colors.purple,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.purple.shade100,
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.purple,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Event Details
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 12 : 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade800,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 14,
                                    color: Colors.blue.shade600,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    event.date,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.orange.shade600,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                event.location,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        if (event.description.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            event.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.green.shade400,
                                    Colors.green.shade600,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                (event.price / 100).toStringAsFixed(2),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),

                            const Spacer(),

                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red.shade600,
                                  size: 20,
                                ),
                                onPressed: () => _showDeleteConfirmation(event),
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Event event) {
    showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.warning, color: Colors.red.shade600),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Delete Event',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Text(
              'Are you sure you want to delete "${event.title}"? This action cannot be undone.',
              style: const TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade400, Colors.red.shade600],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _removeEvent(event.id!);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
