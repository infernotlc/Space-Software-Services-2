import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FirestoreService {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addTarif({
    required String ad,
    required String malzemeler,
    required String tarif,
    required String userId,
    required String imageUrl,
  }) async {
    var id = const Uuid().v1();
    try {
      await _db.collection('tarifler').doc(id).set({
        'id': id,
        'ad': ad,
        'malzemeler': malzemeler,
        'tarif': tarif,
        'userId': userId,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateTarif({
    required String id,
    required String ad,
    required String malzemeler,
    required String tarif,
    required String imageUrl,
  }) async {
    try {
      await _db.collection('tarifler').doc(id).update({
        'ad': ad,
        'malzemeler': malzemeler,
        'tarif': tarif,
        'imageUrl': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Stream<List<Tarif>> getTarifler(String userId) {
    return _db
        .collection('tarifler')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Tarif.fromFirestore(doc))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)));
  }

  Future<void> removeTarif(String id) async {
    try {
      await _db.collection('tarifler').doc(id).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class Tarif {
  String id;
  String ad;
  String malzemeler;
  String tarif;
  String userId;
  String imageUrl;
  Timestamp createdAt;
  Timestamp updatedAt;

  Tarif({
    required this.id,
    required this.ad,
    required this.malzemeler,
    required this.tarif,
    required this.userId,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tarif.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Tarif(
      id: doc.id,
      ad: data['ad'] ?? '',
      malzemeler: data['malzemeler'] ?? '',
      tarif: data['tarif'] ?? '',
      userId: data['userId'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['up datedAt'] ?? Timestamp.now(),

    );
  }
  Map<String, dynamic> toMap() {
    return {
      'ad': ad,
      'malzemeler': malzemeler,
      'tarif': tarif,
      'imageUrl': imageUrl,
    };
  }
}