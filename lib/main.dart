import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'home_view.dart';
import 'about.dart';
import 'visualisationView.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => const HomeView(),
    '/home': (context) => const HomeView(),
    '/visualisation': (context) => const Visualisation(),
    '/about' : (context) => const About(),
  },
));
