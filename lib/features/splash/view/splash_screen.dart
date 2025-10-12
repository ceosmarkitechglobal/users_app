// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSplashScreen extends StatefulWidget {
  const UserSplashScreen({super.key});

  @override
  State<UserSplashScreen> createState() => _UserSplashScreenState();
}

class _UserSplashScreenState extends State<UserSplashScreen> {
  final PageController _pageController = PageController();
  bool _checkingAuth = true;
  int _currentPage = 0;

  final List<Map<String, String>> splashData = [
    {
      "image": "assets/splash/splash1.png",
      "title": "Welcome to [App Name]",
      "subtitle": "Seamless WiFi, Rewards, and Local Shopping in one app",
    },
    {
      "image": "assets/splash/splash2.png",
      "title": "Track Your Rewards",
      "subtitle":
          "Earn points and redeem them instantly at your favorite stores",
    },
    {
      "image": "assets/splash/splash3.png",
      "title": "Stay Connected",
      "subtitle": "Get secure, fast WiFi and exclusive local deals",
    },
    {
      "image": "assets/splash/splash4.png",
      "title": "Find the best local offers",
      "subtitle": "Shop smarter with exclusive deals around you",
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    const secureStorage = FlutterSecureStorage();
    final prefs = await SharedPreferences.getInstance();

    final jwtToken = await secureStorage.read(key: 'jwt_token');
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // ⏳ Wait a bit to show splash instead of instant redirect
    await Future.delayed(const Duration(seconds: 1));

    if (jwtToken != null && jwtToken.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/userHome');
    } else if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/userHome');
    } else {
      // Show onboarding slides
      setState(() => _checkingAuth = false);
    }
  }

  Future<void> _navigateToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _onNextPressed() {
    if (_currentPage < splashData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToNextScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // 🟣 Step 1: show loader while checking auth
    if (_checkingAuth) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset('assets/logo/Logo.png', width: 160, height: 160),
        ),
      );
    }

    // 🟢 Step 2: show onboarding pages only if not logged in
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: splashData.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) => Column(
              children: [
                Container(
                  height: screenHeight * 0.55,
                  width: double.infinity,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Image.asset(
                    splashData[index]['image']!,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),
                Text(
                  splashData[index]['title']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF571094),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: Text(
                    splashData[index]['subtitle']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: screenHeight * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(
                        splashData.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: _currentPage == index ? 20 : 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? const Color(0xFF571094)
                                : Colors.deepPurple.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _onNextPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF571094),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenHeight * 0.010,
                        ),
                      ),
                      child: Text(
                        _currentPage == splashData.length - 1
                            ? "GET STARTED"
                            : "NEXT",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: screenWidth * 0.03,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
