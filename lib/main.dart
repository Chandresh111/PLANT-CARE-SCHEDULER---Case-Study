import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routes/app_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: FloraFloraApp(),
    ),
  );
}

class FloraFloraApp extends StatelessWidget {
  const FloraFloraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'FloraFlora',

      routerConfig: appRouter,

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F6F52),
          brightness: Brightness.light,
        ).copyWith(
          primary: const Color(0xFF4F6F52),
          onPrimary: const Color(0xFFF4F1DE),

          secondary: const Color(0xFF739072),
          onSecondary: const Color(0xFFF4F1DE),

          surface: const Color(0xFFF4F1DE),
          onSurface: const Color(0xFF344E41),

          surfaceContainerHighest:
              const Color(0xFFE8EDDE),

          outline: const Color(0xFF9BAA91),
          outlineVariant: const Color(0xFFC4CDBB),
        ),

        scaffoldBackgroundColor:
            const Color(0xFFF4F1DE),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE8EDDE),
          foregroundColor: Color(0xFF344E41),
          elevation: 0,
        ),

        cardTheme: const CardThemeData(
          elevation: 1,
          margin: EdgeInsets.zero,
          color: Color(0xFFE8EDDE),
        ),

        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFA3B18A),
          foregroundColor: Color(0xFF344E41),
        ),

        navigationBarTheme:
            const NavigationBarThemeData(
          backgroundColor: Color(0xFFDDE6D5),
          indicatorColor: Color(0xFFB7C9A8),
          surfaceTintColor: Color(0xFFDDE6D5),
        ),
      ),
    );
  }
}