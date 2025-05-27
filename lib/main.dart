// main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:timecare/screens/analysis_screen.dart';
import 'package:timecare/screens/ListMedicinesScreen.dart';
import 'package:timecare/screens/ProfileScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timecare/firebase_options.dart';
import 'package:timecare/screens/Medicine_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Relatório Diário',
      theme: ThemeData(fontFamily: GoogleFonts.poppins().fontFamily),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selected = 0;
  late final PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: selected);
  }

  @override
  void dispose() {
    pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: PageView(
        controller: pc,
        onPageChanged: (index) {
          setState(() {
            selected = index;
          });
        },
        children: const [
          MedicineScreen(),
          AnalysisScreen(),
        ],
      ),
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
          barAnimation: BarAnimation.fade,
          iconStyle: IconStyle.animated,
        ),
        items: [
          BottomBarItem(
            icon: Icon(Icons.home),
            title: Text('Início'),
            selectedColor: Colors.blue,
          ),
          BottomBarItem(
            icon: Icon(Icons.pie_chart),
            title: Text('Relatórios'),
            selectedColor: Colors.orange,
          ),
          BottomBarItem(
            icon: Icon(Icons.person),
            title: Text('Perfil'),
            selectedColor: Colors.purple,
          ),
        ],
        currentIndex: selected,
        onTap: (index) {
          setState(() {
            selected = index;
            pc.jumpToPage(index);
          });
        },
      ),
    );
  }
}

