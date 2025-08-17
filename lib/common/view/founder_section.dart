// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shetravels/common/data/founder_provider.dart';
// import 'package:shetravels/common/data/models/founder_message.dart';

// class FounderSection extends ConsumerStatefulWidget {
//   const FounderSection({Key? key}) : super(key: key);

//   @override
//   ConsumerState<FounderSection> createState() => _FounderSectionState();
// }

// class _FounderSectionState extends ConsumerState<FounderSection> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(founderProvider.notifier).loadFounderMessages();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final founderState = ref.watch(founderProvider);

//     if (founderState.isLoading) {
//       return _buildLoadingState();
//     }

//     if (founderState.error != null) {
//       return _buildErrorState(founderState.error!);
//     }

//     if (founderState.founderMessages.isEmpty) {
//       return _buildEmptyState();
//     }

//     final founderMessage = founderState.founderMessages.first;
//     return _buildFounderSection(context, founderMessage);
//   }

//   Widget _buildLoadingState() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
//       child: Center(
//         child: CircularProgressIndicator(
//           valueColor: AlwaysStoppedAnimation<Color>(Colors.pink.shade300),
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorState(String error) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
//       child: Center(
//         child: Column(
//           children: [
//             Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
//             const SizedBox(height: 16),
//             Text(
//               'Error loading founder message',
//               style: GoogleFonts.poppins(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.red.shade400,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               error,
//               style: GoogleFonts.poppins(
//                 fontSize: 14,
//                 color: Colors.black54,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
//       child: Center(
//         child: Column(
//           children: [
//             Icon(Icons.person_outline, size: 48, color: Colors.grey.shade400),
//             const SizedBox(height: 16),
//             Text(
//               'No founder message available',
//               style: GoogleFonts.poppins(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFounderSection(BuildContext context, founderMessage) {
//     // Your UI for showing founderMessage goes here
//     return Padding(
//       padding: const EdgeInsets.all(24.0),
//       child: Text(
//         'test',
//       //  founderMessage.content, // Assuming FounderMessage has 'content'
//         style: GoogleFonts.poppins(fontSize: 16),
//       ),
//     );
//   }
// }
