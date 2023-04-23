import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_firestore/screens/tarif_ekle_screen.dart';
import 'package:firebase_firestore/screens/tarif_list_screen.dart';

void main() async {
  // Firebase kullanımını başlatmak için Firebase.initializeApp() çağrısı
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yemek Tarifleri',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TarifListScreen(kategoriId: '',),
      routes: {
        TarifListScreen.routeName: (ctx) => TarifListScreen(kategoriId: '',),
        TarifEkleScreen.routeName: (ctx) => TarifEkleScreen(),
      },
    );
  }
}
