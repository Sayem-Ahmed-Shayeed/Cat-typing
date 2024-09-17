import 'package:cat_typing/cat_typing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final kColorScheme = ColorScheme.fromSeed(seedColor: const Color(0x6b0a0a0a));

void main() {
   WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((fn){
        runApp(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
       appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.primaryContainer,
          ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            // backgroundColor: const Color(0xff282a36),
            // foregroundColor: const Color(0xfff8f8f2),
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.primaryContainer,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            iconColor: kColorScheme.onPrimaryContainer,
          ),
        ),
        scaffoldBackgroundColor: const Color(0xffa485f1).withOpacity(0.2),
       // scaffoldBackgroundColor:kColorScheme.onPrimaryContainer,
        textTheme: ThemeData().textTheme.copyWith(
              labelLarge: TextStyle(
                color: kColorScheme.primaryContainer,
              ),
            ),
      ),
      debugShowCheckedModeBanner: false,
      home: const TypingTest(),
    ),
  );
      });
}
