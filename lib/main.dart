import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:guia_entrenamiento/app/home/models/session.dart';
import 'package:guia_entrenamiento/app/landing_page.dart';
import 'package:guia_entrenamiento/services/auth.dart';
import 'package:guia_entrenamiento/services/brigade_api.dart';
import 'package:guia_entrenamiento/services/session_api.dart';
import 'package:guia_entrenamiento/services/session_has_training_api.dart';
import 'package:guia_entrenamiento/services/training_api.dart';
import 'package:guia_entrenamiento/services/user_api.dart';
import 'package:provider/provider.dart';

import 'app/home/models/brigade.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthBase>(create: (context) => Auth()),
        ChangeNotifierProvider<BrigadeApi>(create: (_) => BrigadeApi()),
        ChangeNotifierProvider<SessionApi>(create: (_) => SessionApi()),
        ChangeNotifierProvider<UserApi>(create: (_) => UserApi()),
        ChangeNotifierProvider<TrainingApi>(create: (_) => TrainingApi()),
        ChangeNotifierProvider<SessionHasTrainingApi>(create: (_) => SessionHasTrainingApi()),
        Provider<Brigade>(create: (_) => Brigade()),
        Provider<Session>(create: (_) => Session()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          // ... app-specific localization delegate[s] here
          //AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'), // English, no country code
          const Locale('es', 'ES'), // Arabic, no country code
        ],
        title: 'Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: LandingPage(),
      ),
    );
  }
}
