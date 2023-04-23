import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TarifDuzenleScreen extends StatefulWidget {
  const TarifDuzenleScreen({Key? key, required this.tarifId}) : super(key: key);

  final String tarifId;

  @override
  _TarifDuzenleScreenState createState() => _TarifDuzenleScreenState();
}

class _TarifDuzenleScreenState extends State<TarifDuzenleScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _malzemelerController = TextEditingController();
  final TextEditingController _tarifController = TextEditingController();

  late String _ad;
  late String _malzemeler;
  late String _tarif;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getTarifDetails();
  }

  void _getTarifDetails() async {
    setState(() {
      _isLoading = true;
    });

    final DocumentSnapshot snapshot =
    await _firestore.collection('tarifler').doc(widget.tarifId).get();

    setState(() {
      _ad = snapshot['ad'];
      _malzemeler = snapshot['malzemeler'];
      _tarif = snapshot['tarif'];
      _isLoading = false;
    });

    _adController.text = _ad;
    _malzemelerController.text = _malzemeler;
    _tarifController.text = _tarif;
  }

  void _duzenle() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final tarifRef = _firestore.collection('tarifler').doc(widget.tarifId);

      await tarifRef.update({
        'ad': _ad,
        'malzemeler': _malzemeler,
        'tarif': _tarif,
      });

      setState(() {
        _isLoading = false;
      });

      Fluttertoast.showToast(
        msg: "Tarif başarıyla güncellendi",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Tarifi Düzenle'),
    ),
    body: _isLoading
    ? const Center(
    child: CircularProgressIndicator(),
    )
        : SingleChildScrollView(
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Form(
    key: _formKey,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    TextFormField(
    controller: _adController,
    validator: (value) {
    if (value == null || value.isEmpty) {
    return 'Tarif adı boş olamaz';
    }
    return null;
    },
    decoration: const InputDecoration(
    labelText: 'Tarif Adı',
    ),
      onChanged: (value) {
        setState(() {
          _ad = value;
        });
      },
    ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _malzemelerController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Malzemeler boş olamaz';
          }
          return null;
        },
        decoration: const InputDecoration(
          labelText: 'Malzemeler',
        ),
        onChanged: (value) {
          setState(() {
            _malzemeler = value;
          });
        },
        maxLines: null,
        keyboardType: TextInputType.multiline,
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _tarifController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Tarif boş olamaz';
          }
          return null;
        },
        decoration: const InputDecoration(
          labelText: 'Tarif',
        ),
        onChanged: (value) {
          setState(() {
            _tarif = value;
          });
        },
        maxLines: null,
        keyboardType: TextInputType.multiline,
      ),
      const SizedBox(height: 16),
      ElevatedButton(
        onPressed: _duzenle,
        child: const Text('Güncelle'),
      ),
    ],
    ),
    ),
    ),
    ),
    );
  }
}
