import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:respiro/app/router.dart';
import 'package:respiro/core/theme/app_theme.dart';
import 'package:respiro/store/app_store.dart';
import 'package:respiro/features/staff/providers/patient_provider.dart';
import 'package:respiro/features/staff/providers/analytics_provider.dart';

class RespiroApp extends StatelessWidget {
  const RespiroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStore()),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
      ],
      child: MaterialApp.router(
        title: 'Respiro',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: router,
      ),
    );
  }
}
