import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:your_note/screens/main_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryTextTheme: GoogleFonts.martelSansTextTheme(),
        ),
        home: MainScreen(),
        debugShowCheckedModeBanner: false);
  }
}
