// ✅ Safe imports
import 'dart:ui' show ImageFilter;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Firebase config
import 'firebase_options.dart';

// Pages
import 'pages/home_page.dart';
import 'pages/explore_page.dart';
import 'pages/live_page.dart';
import 'pages/profile_page.dart';
import 'pages/StreamPlayerPage.dart';

// Auth
import 'auth/login_page.dart';
import 'auth/signup_page.dart';

// Details
import 'pages/category_detail_page.dart';
import 'pages/stream_detail_page.dart';

// Splash
import 'pages/splash_page.dart';

// Advanced
import 'pages/search_results_page.dart';
import 'pages/settings_page.dart';
import 'pages/edit_profile_page.dart';
import 'pages/notifications_page.dart';
import 'pages/followers_page.dart';
import 'pages/golive_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FluxLiveApp());
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const RootPage(); // ✅ Logged in
        }
        return const LoginPage(); // ❌ Not logged in
      },
    );
  }
}

class FluxLiveApp extends StatelessWidget {
  const FluxLiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flux Live",
      theme: ThemeData.dark(),
      home: const AuthGate(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return MaterialPageRoute(builder: (_) => const SplashPage());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginPage());
          case '/signup':
            return MaterialPageRoute(builder: (_) => const SignupPage());
          case '/root':
            return MaterialPageRoute(builder: (_) => const RootPage());
          case '/search':
            return MaterialPageRoute(builder: (_) => const SearchPage());
          case '/searchResults':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            return MaterialPageRoute(
              builder: (_) => SearchPage(query: args['query'] ?? ''),
            );
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsPage());
          case '/editProfile':
            return MaterialPageRoute(builder: (_) => const EditProfilePage());
          case '/notifications':
            return MaterialPageRoute(builder: (_) => const NotificationsPage());
          case '/followers':
            return MaterialPageRoute(builder: (_) => const FollowersPage());
          case '/goLive':
            return MaterialPageRoute(builder: (_) => const GoLivePage());
          case '/streamPlayer':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            return MaterialPageRoute(
              builder: (_) => StreamPlayerPage(
                streamId: args['streamId'], // Firestore doc id
                hlsUrl: args['hlsUrl'], // HLS video stream URL
                streamerName: args['streamerName'] ?? '',
                title: args['title'] ?? '',
              ),
            );
          case '/categoryDetail':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            return MaterialPageRoute(
              builder: (_) =>
                  CategoryDetailPage(categoryName: args['categoryName'] ?? ''),
            );
          case '/streamDetail':
            final args = settings.arguments as Map<String, dynamic>? ?? {};
            return MaterialPageRoute(
              builder: (_) => StreamDetailPage(
                streamerName: args['streamerName'] ?? '',
                streamTitle: args['streamTitle'] ?? '',
                category: args['category'] ?? '',
                viewers: args['viewers'] ?? '',
                thumbnail: args["thumbnail"] ?? '',
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text("404 - Page not found")),
              ),
            );
        }
      },
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with TickerProviderStateMixin {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ExplorePage(),
    LivePage(),
    ProfilePage(),
  ];

  final List<NavigationDestination> _destinations = const [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home, color: Colors.deepPurpleAccent),
      label: "Home",
    ),
    NavigationDestination(
      icon: Icon(Icons.explore_outlined),
      selectedIcon: Icon(Icons.explore, color: Colors.deepPurpleAccent),
      label: "Explore",
    ),
    NavigationDestination(
      icon: Icon(Icons.videocam_outlined),
      selectedIcon: Icon(Icons.videocam, color: Colors.deepPurpleAccent),
      label: "Live",
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person, color: Colors.deepPurpleAccent),
      label: "Profile",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
          final offsetAnimation = Tween<Offset>(
            begin: const Offset(0.1, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ));
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: offsetAnimation, child: child),
          );
        },
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: Colors.black.withOpacity(0.5),
              indicatorColor: Colors.deepPurpleAccent.withOpacity(0.2),
              labelTextStyle: WidgetStateProperty.all(
                const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
            ),
            child: NavigationBar(
              height: 65,
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() => _currentIndex = index);
              },
              destinations: _destinations,
            ),
          ),
        ),
      ),
    );
  }
}
