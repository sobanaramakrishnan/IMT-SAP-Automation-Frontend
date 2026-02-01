import 'dart:ui';
import 'package:flutter/material.dart';
import '../widgets/side_drawer.dart';
import 'user_login.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use transparent drawer background
      drawer: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: const SideDrawer(),
        ),
      ),
      extendBodyBehindAppBar: true, // to allow gradient behind AppBar
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.6),
        elevation: 0,
        title: const Text(
          "INDO METAL",
          style: TextStyle(
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE0E0E0),
                  Color(0xFFBDBDBD),
                ],
              ),
            ),
          ),
          // Blurred frosted layer
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              color: Colors.white.withOpacity(0.1), // subtle overlay
            ),
          ),
          // Main content
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: kToolbarHeight + 20),
                _heroSection(),
                _divider(),
                _aboutSection(),
                _divider(),
                _ctaSection(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- HERO SECTION ----------------
  Widget _heroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Image.asset(
            "assets/images/indometal_logo.png",
            height: 120,
          ),
          const SizedBox(height: 20),
          const Text(
            "ENGINEERING STRENGTH",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Precision • Durability • Trust",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- DIVIDER ----------------
  Widget _divider() {
    return Container(
      width: 80,
      height: 3,
      color: Colors.redAccent,
      margin: const EdgeInsets.symmetric(vertical: 30),
    );
  }

  // ---------------- ABOUT SECTION ----------------
  Widget _aboutSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: const [
          Text(
            "ABOUT INDO METAL",
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Indo Metal focuses on emerging technologies and continuous "
            "improvement through close collaboration with customers. "
            "We partner with global licensed experts to deliver innovative, "
            "cost-effective, and technology-driven nitriding solutions, "
            "along with engineering and manufacturing services.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- CTA SECTION ----------------
  Widget _ctaSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 6,
              shadowColor: Colors.redAccent.withOpacity(0.6),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UserLogin(),
                ),
              );
            },
            child: const Text(
              "LOGIN TO PORTAL",
              style: TextStyle(
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Authorized Users Only",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
