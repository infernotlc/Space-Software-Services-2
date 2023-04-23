import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_firestore/widgets/tarif_card.dart';
import 'package:firebase_firestore/screens/tarif_detay_screen.dart';
import 'package:firebase_firestore/screens/tarif_ekle_screen.dart';
import 'package:firebase_firestore/services/firestore_service.dart';

class TarifListScreen extends StatefulWidget {
  static const String routeName = '/tarif-listesi';
  final String kategoriId;

  TarifListScreen({required this.kategoriId});

  @override
  _TarifListScreenState createState() => _TarifListScreenState();
}

class _TarifListScreenState extends State<TarifListScreen> {
  late CollectionReference tarifRef;
  late Query tariflerQuery;
  List<Tarif> tarifler = [];

  @override
  void initState() {
    super.initState();
    tarifRef = FirebaseFirestore.instance.collection('tarifler');
    tariflerQuery = tarifRef.where('kategoriId', isEqualTo: widget.kategoriId).orderBy('ad');
    _fetchData();
  }

  Future<void> _fetchData() async {
    final snapshot = await tariflerQuery.get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        tarifler = snapshot.docs
            .map((doc) => Tarif.fromFirestore(doc))
            .toList()
            .cast<Tarif>();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarifler'),
      ),
      body: tarifler.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Tarif Bulunamadı'),
            ElevatedButton(
              child: Text('Yeni Tarif Ekle'),
              onPressed: () async {
                bool? isAdded = await Navigator.pushNamed(
                    context, TarifEkleScreen.routeName);
                await Navigator.pushNamed(context, TarifEkleScreen.routeName)?? false;
                if (isAdded == true) {
                  _fetchData();
                }
              })
          ]
        ),
      )
          : ListView.builder(
        itemCount: tarifler.length,
        itemBuilder: (BuildContext context, int index) {
          Tarif tarif = tarifler[index];
          return TarifCard(
            tarif: tarif,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TarifDetayScreen(docId: tarif.id),
                ),
              );
            },
            onLongPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Emin misiniz?'),
                  content: Text(
                      '${tarif.ad} tarifini silmek istediğinize emin misiniz?'),
                  actions: [
                    TextButton(
                      child: Text('Vazgeç'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: Text('Sil'),
                      onPressed: () async {
                        await tarifRef.doc(tarif.id).delete();
                        setState(() {
                          tarifler.removeAt(index);
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
