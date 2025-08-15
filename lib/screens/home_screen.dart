//============================================================================================================

// // screens/home_screen.dart
// import 'package:flutter/material.dart';
// import 'package:my_flutter_app/models/home_data.dart';
// import 'package:my_flutter_app/models/user_response.dart';
// import 'package:my_flutter_app/screens/notifications_screen.dart';
// import 'package:my_flutter_app/services/api_service.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// class HomeScreen extends StatefulWidget {
//   final String userId;
//   final String phone;
//   final String deviceId;
//   final String osType;

//   const HomeScreen({
//     Key? key,
//     required this.userId,
//     required this.phone,
//     required this.deviceId,
//     required this.osType,
//   }) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late Future<UserResponse> userDataFuture;
//   late Future<HomeData> homeDataFuture;

//   @override
//   void initState() {
//     super.initState();
//     // Fetch user by phone number
//     userDataFuture = ApiService().searchUserByPhone(widget.phone);
//     // Fetch home screen data
//     homeDataFuture = ApiService().getHomeData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: _buildDrawer(),
//       appBar: AppBar(
//         toolbarHeight: 45,
//         title: const Text(
//           'Home',
//           style: TextStyle(
//             fontFamily: 'Calibri',
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Color(0xFF2196F3),
//         leading: Builder(
//           builder: (context) => IconButton(
//             icon: const Icon(Icons.menu, size: 24),
//             onPressed: () => Scaffold.of(context).openDrawer(),
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(
//               Icons.notifications,
//               size: 24,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => NotificationsScreen()),
//               );
//             },
//             tooltip: 'View notifications',
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//       body: FutureBuilder<HomeData>(
//         future: homeDataFuture,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return _buildHomeContent(snapshot.data!);
//           } else if (snapshot.hasError) {
//             return _buildErrorWidget(
//               'Failed to load home data: ${snapshot.error}',
//             );
//           }
//           return const Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }

//   Widget _buildDrawer() {
//     return Drawer(
//       backgroundColor: const Color(0xFF1A1A1A),
//       child: FutureBuilder<UserResponse>(
//         future: userDataFuture,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final user = snapshot.data?.user;
//             if (user == null) {
//               return _buildErrorWidget('User not found');
//             }

//             return ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 // Profile Header
//                 UserAccountsDrawerHeader(
//                   accountName: Text(
//                     user.name ?? 'Guest User',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'Calibri',
//                     ),
//                   ),
//                   accountEmail: Text(
//                     'Update profile',
//                     style: const TextStyle(
//                       color: Colors.blueAccent,
//                       fontSize: 14,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                   currentAccountPicture: CircleAvatar(
//                     radius: 30,
//                     backgroundColor: Colors.transparent,
//                     child: ClipOval(
//                       child: CachedNetworkImage(
//                         imageUrl: (user.image ?? '').trim(),
//                         width: 60,
//                         height: 60,
//                         fit: BoxFit.cover,
//                         placeholder: (context, url) => Container(
//                           color: Colors.green.withOpacity(0.2),
//                           child: const CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         ),
//                         errorWidget: (context, url, error) => Container(
//                           color: Colors.green.withOpacity(0.2),
//                           child: const Icon(
//                             Icons.person,
//                             size: 50,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Color(0xFF2196F3), Color(0xFF1E88E5)],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                   ),
//                   onDetailsPressed: () {
//                     print("Update profile tapped");
//                   },
//                 ),

//                 // Active Status
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 8,
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(
//                         Icons.visibility,
//                         color: Colors.white,
//                         size: 18,
//                       ),
//                       const SizedBox(width: 8),
//                       const Text(
//                         'Actively searching jobs',
//                         style: TextStyle(color: Colors.white, fontSize: 14),
//                       ),
//                       const Spacer(),
//                       IconButton(
//                         icon: const Icon(Icons.edit, color: Colors.blueAccent),
//                         onPressed: () {},
//                         tooltip: 'Edit status',
//                       ),
//                     ],
//                   ),
//                 ),

//                 const Divider(color: Colors.grey, thickness: 1),

//                 // Menu Items
//                 _buildDrawerItem(Icons.search, 'Search jobs'),
//                 _buildDrawerItem(Icons.folder, 'Recommended jobs'),
//                 _buildDrawerItem(Icons.bookmark, 'Saved jobs'),
//                 _buildDrawerItem(Icons.bar_chart, 'Profile performance'),
//                 const Divider(color: Colors.grey, thickness: 1),
//                 _buildDrawerItem(Icons.visibility, 'Display preferences'),
//                 _buildDrawerItem(
//                   Icons.chat,
//                   'Chat for help (New)',
//                   textColor: Colors.redAccent,
//                 ),
//                 _buildDrawerItem(Icons.settings, 'Settings'),
//                 _buildDrawerItem(
//                   Icons.credit_card,
//                   'Jobseeker services (Paid)',
//                 ),
//                 _buildDrawerItem(Icons.menu_book, 'Naukri blog'),
//                 _buildDrawerItem(Icons.help_outline, 'How Naukri works'),
//                 _buildDrawerItem(Icons.mail, 'Write to us'),
//                 _buildDrawerItem(Icons.info, 'About us'),

//                 const Padding(
//                   padding: EdgeInsets.only(
//                     left: 16,
//                     right: 16,
//                     top: 16,
//                     bottom: 8,
//                   ),
//                   child: Text(
//                     'Version 20.57',
//                     style: TextStyle(color: Colors.grey, fontSize: 12),
//                   ),
//                 ),
//               ],
//             );
//           } else if (snapshot.hasError) {
//             return _buildErrorWidget('User load failed: ${snapshot.error}');
//           }
//           return const Center(
//             child: Padding(
//               padding: EdgeInsets.all(16.0),
//               child: CircularProgressIndicator(color: Colors.white),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildHomeContent(HomeData homeData) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           // Main Banner Image
//           SizedBox(
//             height: 280,
//             width: double.infinity,
//             child: Stack(
//               fit: StackFit.expand,
//               children: [
//                 // Background Image
//                 ClipRRect(
//                   borderRadius: BorderRadius.zero,
//                   child: CachedNetworkImage(
//                     imageUrl: homeData.homepageLogo.trim(),
//                     fit: BoxFit.cover,
//                     placeholder: (context, url) =>
//                         const Center(child: CircularProgressIndicator()),
//                     errorWidget: (context, url, error) => const Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.broken_image, color: Colors.red, size: 40),
//                         Text(
//                           "Image not available",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // Gradient Overlay for Text Readability
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.bottomCenter,
//                       end: Alignment.topCenter,
//                       colors: [
//                         Colors.black.withOpacity(0.7),
//                         Colors.transparent,
//                       ],
//                     ),
//                   ),
//                 ),

//                 // Centered Title & Date
//                 Positioned(
//                   bottom: 60,
//                   left: 0,
//                   right: 0,
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 29.0),
//                         child: Text(
//                           homeData.title,
//                           style: const TextStyle(
//                             fontSize: 16.0,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: 'Calibri',
//                             color: Colors.white,
//                             height: 1.3,
//                             letterSpacing: 0.3,
//                             shadows: [
//                               Shadow(
//                                 blurRadius: 4.0,
//                                 color: Colors.black26,
//                                 offset: Offset(1.0, 1.0),
//                               ),
//                             ],
//                           ),
//                           textAlign: TextAlign.center,
//                           maxLines: 5,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                         child: Text(
//                           '${homeData.date} | ${homeData.location}',
//                           style: const TextStyle(
//                             fontSize: 14.0,
//                             fontWeight: FontWeight.w500,
//                             fontFamily: 'Calibri',
//                             color: Colors.white,
//                             height: 1.3,
//                             letterSpacing: 0.3,
//                             shadows: [
//                               Shadow(
//                                 blurRadius: 4.0,
//                                 color: Colors.black26,
//                                 offset: Offset(1.0, 1.0),
//                               ),
//                             ],
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Event Logo - Top Left
//                 Positioned(
//                   top: 10,
//                   left: 10,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: CachedNetworkImage(
//                       imageUrl: homeData.eventLogo.trim(),
//                       width: 40,
//                       height: 40,
//                       placeholder: (context, url) => const CircleAvatar(
//                         backgroundColor: Colors.grey,
//                         child: Icon(Icons.image, size: 20, color: Colors.white),
//                       ),
//                       errorWidget: (context, url, error) => const CircleAvatar(
//                         backgroundColor: Colors.grey,
//                         child: Icon(Icons.broken_image, size: 20),
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Institution Logo - Top Right
//                 Positioned(
//                   top: 10,
//                   right: 10,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: CachedNetworkImage(
//                       imageUrl: homeData.institutionLogo.trim(),
//                       width: 40,
//                       height: 40,
//                       placeholder: (context, url) => const CircleAvatar(
//                         backgroundColor: Colors.grey,
//                         child: Icon(Icons.image, size: 20, color: Colors.white),
//                       ),
//                       errorWidget: (context, url, error) => const CircleAvatar(
//                         backgroundColor: Colors.grey,
//                         child: Icon(Icons.broken_image, size: 20),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Description Card
//           Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 16.0,
//               vertical: 16.0,
//             ),
//             child: Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(
//                   homeData.description,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontFamily: 'Calibri',
//                     height: 1.5,
//                   ),
//                   textAlign: TextAlign.justify,
//                 ),
//               ),
//             ),
//           ),

//           // Action Button
//           Padding(
//             padding: const EdgeInsets.only(
//               left: 16.0,
//               right: 16.0,
//               bottom: 16.0,
//               top: 32.0,
//             ),
//             child: ElevatedButton(
//               onPressed: () {
//                 print("Button pressed: ${homeData.buttonText}");
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF2196F3),
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.arrow_forward, size: 18),
//                   const SizedBox(width: 8),
//                   Text(homeData.buttonText),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorWidget(String message) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.error, color: Colors.red),
//           const SizedBox(height: 8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Text(
//               message,
//               style: const TextStyle(fontSize: 16),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   ListTile _buildDrawerItem(IconData icon, String title, {Color? textColor}) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.white),
//       title: Text(title, style: TextStyle(color: textColor ?? Colors.white)),
//       onTap: () => Navigator.pop(context),
//     );
//   }
// }

//==============================================================================================================

// screens/home_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/models/home_data.dart';
import 'package:my_flutter_app/models/user_response.dart';
import 'package:my_flutter_app/screens/EditStatusScreen.dart';
import 'package:my_flutter_app/screens/agenda_screen.dart';
import 'package:my_flutter_app/screens/assessment_screen.dart';
import 'package:my_flutter_app/screens/contact_us_screen.dart';
import 'package:my_flutter_app/screens/documents_screen.dart';
import 'package:my_flutter_app/screens/live_engagement_screen.dart';
import 'package:my_flutter_app/screens/login_screen.dart';
import 'package:my_flutter_app/screens/logout_screen.dart';
import 'package:my_flutter_app/screens/map_screen.dart';
import 'package:my_flutter_app/screens/notifications_screen.dart';
import 'package:my_flutter_app/screens/schedule_screen.dart';
import 'package:my_flutter_app/screens/sessions_screen.dart';
import 'package:my_flutter_app/screens/venue_screen.dart';
import 'package:my_flutter_app/services/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  final String phone;
  final String deviceId;
  final String osType;

  const HomeScreen({
    super.key,
    required this.userId,
    required this.phone,
    required this.deviceId,
    required this.osType,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<UserResponse> userDataFuture;
  late Future<HomeData> homeDataFuture;

  // For banner carousel
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    userDataFuture = ApiService().searchUserByPhone(widget.phone);
    homeDataFuture = ApiService().getHomeData();

    _pageController = PageController(initialPage: 0);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        toolbarHeight: 45,
        title: const Text(
          'Home',
          style: TextStyle(
            fontFamily: 'Calibri',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 225, 228, 230),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, size: 24),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              size: 24,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
            },
            tooltip: 'View notifications',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<HomeData>(
        future: homeDataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final homeData = snapshot.data!;

            // ✅ Build banners from API data
            final List<String> banners = [
              if (homeData.eventLogo.trim().isNotEmpty == true)
                homeData.eventLogo.trim(),
              if (homeData.institutionLogo.trim().isNotEmpty == true)
                homeData.institutionLogo.trim(),
              if (homeData.homepageLogo.trim().isNotEmpty == true)
                homeData.homepageLogo.trim(),
            ];

            // Fallback if no valid images
            if (banners.isEmpty) {
              banners.add(
                'https://via.placeholder.com/800x300.png?text=No+Image+Available',
              );
            }

            // Update _startAutoScroll to use dynamic length
            _startAutoScrollWithLength(banners.length);

            return SingleChildScrollView(
              child: Column(
                children: [
                  // 🔁 Auto-Scrolling Banner Carousel
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 280,
                          child: PageView.builder(
                            itemCount: banners.length,
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return _buildBanner(banners[index]);
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Indicator Dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _buildIndicatorDots(banners.length),
                        ),
                      ],
                    ),
                  ),

                  // 🔧 Bottom Tool Icons
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // ✅ Assessment: Navigate to AssessmentScreen
                        _buildToolIcon(Icons.checklist, 'Assessment', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AssessmentScreen(),
                            ),
                          );
                        }),

                        // Career Path (example placeholder)
                        _buildToolIcon(Icons.edit_document, 'Q&A', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              // builder: (context) => DocumentsScreen(),
                              builder: (context) => LiveEngagementScreen(),
                            ),
                          );
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(content: Text('Career Path coming soon!')),
                          // );
                        }),

                        // Dream Job (example placeholder)
                        _buildToolIcon(Icons.book, 'Sessions', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SessionsScreen(),
                            ),
                          );
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Text('Dream Job feature coming soon!'),
                          //   ),
                          // );
                        }),
                      ],
                    ),
                  ),

                  // Description Card
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          homeData.description,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Calibri',
                            height: 1.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ),

                  // Action Button
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 32.0,
                      top: 16.0,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        print("Button pressed: ${homeData.buttonText}");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.arrow_forward, size: 18),
                          const SizedBox(width: 8),
                          Text(homeData.buttonText),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(height: 8),
                  Text(
                    'Failed to load data: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  // Update auto-scroll to support dynamic banner count
  void _startAutoScrollWithLength(int length) {
    _timer?.cancel(); // Cancel old timer
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Widget _buildBanner(String imageUrl) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.zero,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, color: Colors.red, size: 40),
                Text(
                  "Image not available",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            ),
          ),
        ),
        // Text overlay
        Positioned(
          bottom: 60,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 29.0),
                child: Text(
                  "Stay Ahead in Your Career",
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Calibri',
                    color: Colors.white,
                    height: 1.3,
                    letterSpacing: 0.3,
                    shadows: [
                      Shadow(
                        blurRadius: 4.0,
                        color: Colors.black26,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "Discover new opportunities, build your profile, and get hired faster.",
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Calibri',
                    color: Colors.white,
                    height: 1.3,
                    letterSpacing: 0.3,
                    shadows: [
                      Shadow(
                        blurRadius: 4.0,
                        color: Colors.black26,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildIndicatorDots(int total) {
    return List.generate(total, (index) {
      return Container(
        width: 10,
        height: 10,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentPage == index ? Colors.black : Colors.grey[400],
        ),
      );
    });
  }

  // Widget _buildToolIcon(IconData icon, String label) {
  //   return Column(
  //     children: [
  //       Container(
  //         width: 60,
  //         height: 60,
  //         decoration: BoxDecoration(
  //           shape: BoxShape.circle,
  //           color: Colors.teal.withOpacity(0.1),
  //           border: Border.all(color: Colors.teal, width: 1),
  //         ),
  //         child: Icon(icon, size: 24, color: Colors.teal),
  //       ),
  //       const SizedBox(height: 8),
  //       Text(
  //         label,
  //         style: const TextStyle(
  //           fontSize: 14,
  //           fontWeight: FontWeight.w500,
  //           color: Colors.teal,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildToolIcon(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.teal.withOpacity(0.1),
              border: Border.all(color: Colors.teal, width: 1),
            ),
            child: Icon(icon, size: 24, color: Colors.teal),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF1A1A1A),
      child: FutureBuilder<UserResponse>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data?.user;
            if (user == null) {
              return _buildErrorWidget('User not found');
            }

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    user.name ?? 'Guest User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Calibri',
                    ),
                  ),
                  accountEmail: Text(
                    'Update profile',
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  currentAccountPicture: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: (user.image ?? '').trim(),
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.green.withOpacity(0.2),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.green.withOpacity(0.2),
                          child: const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF1E88E5)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  onDetailsPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LogoutScreen()),
                    );
                  },
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 16,
                //     vertical: 8,
                //   ),
                //   child: Row(
                //     children: [
                //       const Icon(
                //         Icons.visibility,
                //         color: Colors.white,
                //         size: 18,
                //       ),
                //       const SizedBox(width: 8),
                //       const Text(
                //         'Actively searching conferences',
                //         style: TextStyle(color: Colors.white, fontSize: 14),
                //       ),
                //       const Spacer(),
                //       IconButton(
                //         icon: const Icon(Icons.edit, color: Colors.blueAccent),
                //         onPressed: () {
                //           Navigator.pop(context); // Close drawer first
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => EditStatusScreen(
                //                 currentStatus: 'Actively searching conferences',
                //               ),
                //             ),
                //           );
                //         },
                //         tooltip: 'Edit status',
                //       ),
                //     ],
                //   ),
                // ),
                // const Divider(color: Colors.grey, thickness: 1),
                // Conference-specific drawer items with navigation
                _buildDrawerItem(
                  Icons.search,
                  'Search Conferences',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LiveEngagementScreen(),
                    ),
                  ),
                ),
                const Divider(color: Colors.grey, thickness: 1),
                _buildDrawerItem(
                  Icons.calendar_today,
                  'Upcoming Conferences',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LiveEngagementScreen(),
                    ),
                  ),
                ),
                _buildDrawerItem(
                  Icons.bookmark,
                  'Saved Conferences',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AgendaScreen()),
                  ),
                ),
                _buildDrawerItem(
                  Icons.bar_chart,
                  'Conference Interests',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AssessmentScreen()),
                  ),
                ),
                const Divider(color: Colors.grey, thickness: 1),
                _buildDrawerItem(
                  Icons.visibility,
                  'Display preferences',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SessionsScreen()),
                  ),
                ),
                _buildDrawerItem(
                  Icons.chat,
                  'Conference Support (New)',
                  textColor: Colors.redAccent,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LiveEngagementScreen(),
                    ),
                  ),
                ),
                _buildDrawerItem(
                  Icons.settings,
                  'Map',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapScreen()),
                  ),
                ),
                _buildDrawerItem(
                  Icons.credit_card,
                  'Premium Conference Access',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AssessmentScreen()),
                  ),
                ),
                _buildDrawerItem(
                  Icons.menu_book,
                  'Conference News',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AssessmentScreen()),
                  ),
                ),
                _buildDrawerItem(
                  Icons.people,
                  'Speakers & Guests',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SessionsScreen()),
                  ),
                ),
                _buildDrawerItem(
                  Icons.map,
                  'Venue Information',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VenueScreen()),
                  ),
                ),
                _buildDrawerItem(
                  Icons.schedule,
                  'Conference Schedule',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScheduleScreen()),
                  ),
                ),
                _buildDrawerItem(
                  Icons.schedule,
                  'About Us',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactUsScreen()),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 8,
                  ),
                  child: Text(
                    'Version 20.57',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                //=============================logout option=========================
                const Divider(color: Colors.grey, thickness: 1),

                // _buildDrawerItem(
                //   Icons.exit_to_app,
                //   'Logout',
                //   textColor: Colors.redAccent,
                //   onTap: () {
                //     Navigator.pop(context); // Close drawer
                //     _showLogoutConfirmationDialog(context);
                //   },
                // ),
                _buildDrawerItem(
                  Icons.person_outline,
                  'Profile',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogoutScreen()),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 8,
                  ),
                  child: Text(
                    'Version 20.57',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return _buildErrorWidget('User load failed: ${snapshot.error}');
          }
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  //================================================method for logout

  // Updated _buildDrawerItem method with navigation support
  ListTile _buildDrawerItem(
    IconData icon,
    String title, {
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: textColor ?? Colors.white, fontSize: 14),
      ),
      onTap:
          onTap ??
          () {
            Navigator.pop(context); // Close drawer first
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('$title selected')));
          },
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
