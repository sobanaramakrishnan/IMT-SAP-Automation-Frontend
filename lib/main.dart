import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/view_dc_details.dart';

final ValueNotifier<ThemeMode> appThemeMode =
    ValueNotifier(ThemeMode.light);

void toggleAppTheme() {
  appThemeMode.value = appThemeMode.value == ThemeMode.light
      ? ThemeMode.dark
      : ThemeMode.light;
}

class ThemeToggleAction extends StatelessWidget {
  const ThemeToggleAction({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
        tooltip: Theme.of(context).brightness == Brightness.light
            ? 'Switch to dark mode'
            : 'Switch to light mode',
        onPressed: toggleAppTheme,
        icon: Icon(
          Theme.of(context).brightness == Brightness.light
              ? Icons.dark_mode_rounded
              : Icons.light_mode_rounded,
        ),
      );
}

ThemeData _buildTheme(Brightness brightness) {
  const brand = Color(0xFF8B174A);
  final dark = brightness == Brightness.dark;

  final scheme = ColorScheme.fromSeed(
    seedColor: brand,
    brightness: brightness,
    primary: brand,
    secondary: const Color(0xFFCA8A04),
    surface: dark ? const Color(0xFF1D2530) : Colors.white,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor:
        dark ? const Color(0xFF111821) : const Color(0xFFF4F6F9),
    appBarTheme: AppBarTheme(
      backgroundColor: dark ? const Color(0xFF1D2530) : brand,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: .2,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: dark ? const Color(0xFF1D2530) : Colors.white,
      elevation: dark ? 0 : 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: dark
              ? const Color(0xFF354150)
              : const Color(0xFFE4E8EF),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: dark
          ? const Color(0xFF17202B)
          : const Color(0xFFFAFBFD),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: dark
              ? const Color(0xFF475569)
              : const Color(0xFFD7DDE6),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: dark
              ? const Color(0xFF475569)
              : const Color(0xFFD7DDE6),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: brand,
          width: 1.8,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    textTheme: ThemeData(
      useMaterial3: true,
      brightness: brightness,
      ).textTheme,
    dividerColor:
        dark ? const Color(0xFF354150) : const Color(0xFFE0E5EC),
  );
}

void main() => runApp(const IndoMetalApp());

class IndoMetalApp extends StatelessWidget {
  const IndoMetalApp({super.key});

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<ThemeMode>(
        valueListenable: appThemeMode,
        builder: (context, mode, _) => MaterialApp(
          title: 'IndoMetal',
          debugShowCheckedModeBanner: false,
          theme: _buildTheme(Brightness.light),
          darkTheme: _buildTheme(Brightness.dark),
          themeMode: mode,
          initialRoute: '/',
          routes: {
            '/': (context) => const HomePage(),
            '/view_dc_details': (context) => const ViewDcDetails(),
          },
        ),
      );
}