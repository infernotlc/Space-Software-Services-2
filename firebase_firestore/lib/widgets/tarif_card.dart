import 'package:flutter/material.dart';
import 'package:firebase_firestore/screens/tarif_detay_screen.dart';
import 'package:firebase_firestore/services/firestore_service.dart';

class TarifCard extends StatefulWidget {
  const TarifCard({Key? key, required this.tarif, this.onPressed, this.onLongPressed}) : super(key: key);

  final Tarif tarif;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPressed;

  @override
  State<TarifCard> createState() => TarifCardState();
}

class TarifCardState extends State<TarifCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TarifDetayScreen(docId: widget.tarif.id,),
          ),
        );
      },
      child: SizedBox(
        height: 150.0,
        child: Card(
          child: Row(
            children: [
              Container(
                width: 150.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.tarif.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.tarif.ad,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Expanded(
                        child: Text(
                          widget.tarif.malzemeler,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
