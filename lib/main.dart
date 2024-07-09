import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'screens/main_menu.dart';
import 'services/training_mode_service.dart';
import 'services/language_service.dart';
import 'services/quiz_service.dart';
import 'services/theme_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TrainingModeService()),
        ChangeNotifierProvider(create: (context) => LanguageService()),
        Provider(create: (context) => QuizService()),
        ChangeNotifierProvider(create: (context) => ThemeService()),
      ],
      child: Consumer2<LanguageService, ThemeService>(
        builder: (context, languageService, themeService, child) {
          return MaterialApp(
            title: 'Einbürgerungstest App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: const Color(0xFF1E88E5), // Blau
              scaffoldBackgroundColor: Colors.white,
              cardColor: Colors.white,
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.black87),
                bodyMedium: TextStyle(color: Colors.black87),
                titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  foregroundColor: Colors.white,
                ),
              ),
              iconTheme: const IconThemeData(color: Color(0xFF1E88E5)),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: const Color(0xFF1E88E5), // Blau
              scaffoldBackgroundColor: const Color(0xFF121212),
              cardColor: const Color(0xFF1E1E1E),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Colors.white70),
                bodyMedium: TextStyle(color: Colors.white70),
                titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  foregroundColor: Colors.white,
                ),
              ),
              iconTheme: const IconThemeData(color: Color(0xFF1E88E5)),
            ),
            themeMode: themeService.darkMode ? ThemeMode.dark : ThemeMode.light,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('de'),
              Locale('en'),
              Locale('tr'),
              Locale('ar'),
            ],
            locale: languageService.currentLocale,
            home: const MainMenu(),
          );
        },
      ),
    );
  }
}