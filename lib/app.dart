import 'package:flutter/material.dart';
import 'package:planpro/constants/app_theme.dart';
import 'package:planpro/screens/splash_screen.dart';

class WeeklyPlannerApp extends StatelessWidget {
  const WeeklyPlannerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlanPro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // veya ThemeMode.system
      home: const SplashScreen(),
    );
  }
}
