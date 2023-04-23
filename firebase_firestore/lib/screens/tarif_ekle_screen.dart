import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class TarifEkleScreen extends StatefulWidget {
  static const routeName = '/tarif-ekle';

  @override
  _TarifEkleScreenState createState() => _TarifEkleScreenState();
}

class _TarifEkleScreenState extends State<TarifEkleScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _malzemelerController = TextEditingController();
  final TextEditingController _tarifOzetiController = TextEditingController();
  final TextEditingController _tarifAsamalariController = TextEditingController();

  void _addTarif() async {
    String ad = _adController.text;
    String malzemeler = _malzemelerController.text;
    String tarifOzeti = _tarifOzetiController.text;
    String tarifAsamalari = _tarifAsamalariController.text;

    Map<String, dynamic> tarifData = {
      'ad': ad,
      'malzemeler': malzemeler,
      'tarif_ozeti': tarifOzeti,
      'tarif_asamalari': tarifAsamalari,
    };

    await _firestore.collection('tarifler').add(tarifData);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarif Ekle'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _adController,
                decoration: InputDecoration(
                  labelText: 'Tarif Adı',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _malzemelerController,
                decoration: InputDecoration(
                  labelText: 'Malzemeler',
                ),
                maxLines: null,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _tarifOzetiController,
                decoration: InputDecoration(
                  labelText: 'Tarif Özeti',
                ),
                maxLines: null,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _tarifAsamalariController,
                decoration: InputDecoration(
                  labelText: 'Tarif Aşamaları',
                ),
                maxLines: null,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addTarif,
                child: Text('Ekle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
