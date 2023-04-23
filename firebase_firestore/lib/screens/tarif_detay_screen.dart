import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TarifDetayScreen extends StatelessWidget {
  final String docId;
  TarifDetayScreen({required this.docId});

  @override
  Widget build(BuildContext context) {
    CollectionReference tarifRef = FirebaseFirestore.instance.collection('tarifler');
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarif Detayı'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: tarifRef.doc(docId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Bir hata oluştu: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final tarif = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(tarif['foto']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tarif['ad'],
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Malzemeler',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(tarif['malzemeler']),
                      SizedBox(height: 10),
                      Text(
                        'Tarif Özeti',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(tarif['ozet']),
                      SizedBox(height: 10),
                      Text(
                        'Tarif Aşamaları',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List<Widget>.from(
                          tarif['asamalar'].map(
                                (asama) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(asama),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
