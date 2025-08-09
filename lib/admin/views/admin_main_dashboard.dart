import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shetravels/admin/views/admin_gallery.dart';
import 'package:shetravels/admin/views/admin_manage_event.dart';
import 'package:shetravels/admin/views/admin_memories_page.dart';
import 'package:shetravels/booking/views/admin_booking_dashboard.dart';
import 'package:shetravels/utils/route.gr.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';


@RoutePage()


// Import your screen widgets here
// Make sure to import all your actual screen classes
// import 'admin_manage_event.dart'; // Your AdminManageEvent widget
// import 'admin_gallery_screen.dart'; // Your gallery screen
// import 'admin_memories_screen.dart'; // Your memories screen  
// import 'admin_booking_dashboard_screen.dart'; // Your bookings screen

@RoutePage()
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.event_rounded,
      label: 'Manage Events',
      color: const Color(0xFF667eea),
    ),
    NavigationItem(
      icon: Icons.photo_library_rounded,
      label: 'Manage Gallery',
      color: const Color(0xFF764ba2),
    ),
    NavigationItem(
      icon: Icons.favorite_rounded,
      label: 'Memories',
      color: const Color(0xFFf093fb),
    ),
    NavigationItem(
      icon: Icons.book_online_rounded,
      label: 'View Bookings',
      color: const Color(0xFF4ecdc4),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  bool get isWeb => MediaQuery.of(context).size.width > 768;

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    context.router.push(AdminLoginRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFf8f9fa),
              Color(0xFFe9ecef),
            ],
          ),
        ),
        child: isWeb ? _buildWebLayout() : _buildMobileLayout(),
      ),
      bottomNavigationBar: isWeb ? null : _buildBottomNavigation(),
    );
  }

  Widget _buildWebLayout() {
    return Row(
      children: [
        // Side Navigation
        Container(
          width: 280,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF667eea),
                Color(0xFF764ba2),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "SheTravels",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      "Admin Dashboard",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Navigation Items
              Expanded(
                child: ListView.builder(
                  itemCount: _navigationItems.length,
                  itemBuilder: (context, index) {
                    final item = _navigationItems[index];
                    final isSelected = _selectedIndex == index;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => setState(() => _selectedIndex = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              border: isSelected
                                  ? Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                    )
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  item.icon,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  item.label,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
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
              ),

              // Logout Button
              Container(
                margin: const EdgeInsets.all(16),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _logout,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 16),
                          Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Main Content
        Expanded(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildMainContent(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Mobile Header
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings_rounded,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SheTravels",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Admin Dashboard",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _logout,
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Main Content
        Expanded(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildMainContent(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = _selectedIndex == index;

              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? item.color.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? item.color.withOpacity(0.2)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item.icon,
                          color: isSelected ? item.color : Colors.grey[600],
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label.split(' ').first,
                        style: TextStyle(
                          color: isSelected ? item.color : Colors.grey[600],
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Header
          Text(
            "Welcome back, Admin! 👋",
            style: TextStyle(
              fontSize: isWeb ? 32 : 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2c3e50),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Manage your travel community with ease",
            style: TextStyle(
              fontSize: isWeb ? 18 : 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),

          // Current Section Content
          Expanded(
            child: _buildSectionContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContent() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: _getCurrentScreen(),
      ),
    );
  }

  Widget _getCurrentScreen() {
    switch (_selectedIndex) {
      case 0: // Manage Events
        return const AdminManageEventScreen();
      case 1: // Manage Gallery
        return const AdminGalleryScreen(); // Replace with your actual gallery screen widget
      case 2: // Memories
        return const AdminMemoriesScreen(); // Replace with your actual memories screen widget
      case 3: // View Bookings
        return const AdminBookingDashboardScreen(); // Replace with your actual bookings screen widget
      default:
        return _buildDefaultContent();
    }
  }

  Widget _buildDefaultContent() {
    final currentItem = _navigationItems[_selectedIndex];
    
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  currentItem.color,
                  currentItem.color.withOpacity(0.7),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: currentItem.color.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              currentItem.icon,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            currentItem.label,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2c3e50),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "This feature is coming soon!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final Color color;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.color,
  });
}





// class AdminDashboardScreen extends StatefulWidget {
//   const AdminDashboardScreen({super.key});

//   @override
//   State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
// }

// class _AdminDashboardScreenState extends State<AdminDashboardScreen>
//     with TickerProviderStateMixin {
//   int _selectedIndex = 0;
//   late AnimationController _fadeController;
//   late AnimationController _slideController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   final List<NavigationItem> _navigationItems = [
//     NavigationItem(
//       icon: Icons.event_rounded,
//       label: 'Manage Events',
//       color: const Color(0xFF667eea),
//     ),
//     NavigationItem(
//       icon: Icons.photo_library_rounded,
//       label: 'Manage Gallery',
//       color: const Color(0xFF764ba2),
//     ),
//     NavigationItem(
//       icon: Icons.favorite_rounded,
//       label: 'Memories',
//       color: const Color(0xFFf093fb),
//     ),
//     NavigationItem(
//       icon: Icons.book_online_rounded,
//       label: 'View Bookings',
//       color: const Color(0xFF4ecdc4),
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
//     );
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0.3, 0),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
//     );

//     _fadeController.forward();
//     _slideController.forward();
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _slideController.dispose();
//     super.dispose();
//   }

//   bool get isWeb => MediaQuery.of(context).size.width > 768;

//   Future<void> _logout() async {
//     await FirebaseAuth.instance.signOut();
//     context.router.push(AdminLoginRoute());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Color(0xFFf8f9fa), Color(0xFFe9ecef)],
//           ),
//         ),
//         child: isWeb ? _buildWebLayout() : _buildMobileLayout(),
//       ),
//       bottomNavigationBar: isWeb ? null : _buildBottomNavigation(),
//     );
//   }

//   Widget _buildWebLayout() {
//     return Row(
//       children: [
//         // Side Navigation
//         Container(
//           width: 280,
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 20,
//                 offset: const Offset(0, 0),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               // Header
//               Container(
//                 padding: const EdgeInsets.all(32.0),
//                 child: Column(
//                   children: [
//                     Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: Colors.white.withOpacity(0.3),
//                           width: 2,
//                         ),
//                       ),
//                       child: const Icon(
//                         Icons.admin_panel_settings_rounded,
//                         size: 40,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       "SheTravels",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         letterSpacing: 1.2,
//                       ),
//                     ),
//                     Text(
//                       "Admin Dashboard",
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.8),
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Navigation Items
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: _navigationItems.length,
//                   itemBuilder: (context, index) {
//                     final item = _navigationItems[index];
//                     final isSelected = _selectedIndex == index;

//                     return Container(
//                       margin: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 4,
//                       ),
//                       child: Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           borderRadius: BorderRadius.circular(16),
//                           onTap: () => setState(() => _selectedIndex = index),
//                           child: AnimatedContainer(
//                             duration: const Duration(milliseconds: 300),
//                             curve: Curves.easeInOut,
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color:
//                                   isSelected
//                                       ? Colors.white.withOpacity(0.2)
//                                       : Colors.transparent,
//                               borderRadius: BorderRadius.circular(16),
//                               border:
//                                   isSelected
//                                       ? Border.all(
//                                         color: Colors.white.withOpacity(0.3),
//                                       )
//                                       : null,
//                             ),
//                             child: Row(
//                               children: [
//                                 Icon(item.icon, color: Colors.white, size: 24),
//                                 const SizedBox(width: 16),
//                                 Text(
//                                   item.label,
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 16,
//                                     fontWeight:
//                                         isSelected
//                                             ? FontWeight.w600
//                                             : FontWeight.w400,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),

//               // Logout Button
//               Container(
//                 margin: const EdgeInsets.all(16),
//                 child: Material(
//                   color: Colors.transparent,
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(16),
//                     onTap: _logout,
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(
//                           color: Colors.white.withOpacity(0.2),
//                         ),
//                       ),
//                       child: const Row(
//                         children: [
//                           Icon(
//                             Icons.logout_rounded,
//                             color: Colors.white,
//                             size: 24,
//                           ),
//                           SizedBox(width: 16),
//                           Text(
//                             "Logout",
//                             style: TextStyle(color: Colors.white, fontSize: 16),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),

//         // Main Content
//         Expanded(
//           child: FadeTransition(
//             opacity: _fadeAnimation,
//             child: SlideTransition(
//               position: _slideAnimation,
//               child: _buildMainContent(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildMobileLayout() {
//     return Column(
//       children: [
//         // Mobile Header
//         Container(
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 50,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       shape: BoxShape.circle,
//                       border: Border.all(
//                         color: Colors.white.withOpacity(0.3),
//                         width: 2,
//                       ),
//                     ),
//                     child: const Icon(
//                       Icons.admin_panel_settings_rounded,
//                       size: 24,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   const Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "SheTravels",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           "Admin Dashboard",
//                           style: TextStyle(color: Colors.white70, fontSize: 12),
//                         ),
//                       ],
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: _logout,
//                     icon: const Icon(Icons.logout_rounded, color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),

//         // Main Content
//         Expanded(
//           child: FadeTransition(
//             opacity: _fadeAnimation,
//             child: SlideTransition(
//               position: _slideAnimation,
//               child: _buildMainContent(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBottomNavigation() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 20,
//             offset: const Offset(0, -5),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children:
//                 _navigationItems.asMap().entries.map((entry) {
//                   final index = entry.key;
//                   final item = entry.value;
//                   final isSelected = _selectedIndex == index;

//                   return GestureDetector(
//                     onTap: () => setState(() => _selectedIndex = index),
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 8,
//                       ),
//                       decoration: BoxDecoration(
//                         color:
//                             isSelected
//                                 ? item.color.withOpacity(0.1)
//                                 : Colors.transparent,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           AnimatedContainer(
//                             duration: const Duration(milliseconds: 300),
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color:
//                                   isSelected
//                                       ? item.color.withOpacity(0.2)
//                                       : Colors.transparent,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               item.icon,
//                               color: isSelected ? item.color : Colors.grey[600],
//                               size: 24,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             item.label.split(' ').first,
//                             style: TextStyle(
//                               color: isSelected ? item.color : Colors.grey[600],
//                               fontSize: 12,
//                               fontWeight:
//                                   isSelected
//                                       ? FontWeight.w600
//                                       : FontWeight.w400,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }).toList(),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMainContent() {
//     return Padding(
//       padding: const EdgeInsets.all(24.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Welcome Header
//           Text(
//             "Welcome back, Admin! 👋",
//             style: TextStyle(
//               fontSize: isWeb ? 32 : 24,
//               fontWeight: FontWeight.bold,
//               color: const Color(0xFF2c3e50),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             "Manage your travel community with ease",
//             style: TextStyle(
//               fontSize: isWeb ? 18 : 16,
//               color: Colors.grey[600],
//             ),
//           ),
//           const SizedBox(height: 32),

//           // Current Section Content
//           Expanded(child: _buildSectionContent()),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionContent() {
//     final currentItem = _navigationItems[_selectedIndex];

//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(32.0),
//         child: Column(
//           children: [
//             // Section Header
//             Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     currentItem.color,
//                     currentItem.color.withOpacity(0.7),
//                   ],
//                 ),
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: currentItem.color.withOpacity(0.3),
//                     blurRadius: 20,
//                     offset: const Offset(0, 10),
//                   ),
//                 ],
//               ),
//               child: Icon(currentItem.icon, size: 40, color: Colors.white),
//             ),
//             const SizedBox(height: 24),

//             Text(
//               currentItem.label,
//               style: const TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF2c3e50),
//               ),
//             ),
//             const SizedBox(height: 40),

//             // Action Buttons
//             Wrap(
//               spacing: 16,
//               runSpacing: 16,
//               alignment: WrapAlignment.center,
//               children: _getSectionActions(currentItem.label),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> _getSectionActions(String section) {
//     final currentItem = _navigationItems[_selectedIndex];

//     switch (section) {
//       case 'Manage Events':
//         return AdminManageEventRoute();

//       case 'Manage Gallery':
//         return AdminGalleryRoute();

//       case 'Memories':
//         return AdminMemoriesRoute();
//       case 'View Bookings':
//         return AdminBookingDashboardRoute();
//       default:
//         return [];
//     }
//   }

// }

// class NavigationItem {
//   final IconData icon;
//   final String label;
//   final Color color;

//   NavigationItem({
//     required this.icon,
//     required this.label,
//     required this.color,
//   });
// }
