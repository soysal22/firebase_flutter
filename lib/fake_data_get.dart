// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FakeDAtaGet extends StatefulWidget {
  const FakeDAtaGet({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FakeDAtaGetState createState() => _FakeDAtaGetState();
}

class _FakeDAtaGetState extends State<FakeDAtaGet> {
  @override
  Widget build(BuildContext context) {
    return _buildbodyItem(context, dummySnapshot);
  }

  Widget _buildbodyItem(BuildContext context, List<Map> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20),
      children: snapshot
          .map<Widget>((data) => _buildListItem(context, data))
          .toList(),
    );
  }

  _buildListItem(BuildContext context, Map data) {
    final kayit = Anket.fromMap(data);

    return Padding(
        key: ValueKey(kayit.isim),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            title: Text(kayit.isim.toString()),
            subtitle: Text(kayit.oy.toString()),
            onTap: () => print(kayit),
          ),
        ));
  }
}

final dummySnapshot = [
  {"isim": "Css", "oy": 5},
  {"isim": "Java", "oy": 2},
  {"isim": "Go", "oy": 0},
  {"isim": "Python", "oy": 8},
  {"isim": "C ", "oy": 10},
  {"isim": "DArt", "oy": 4},
  {"isim": "Sql", "oy": 9},
];

class Anket {
  String? isim;
  int? oy;
  DocumentReference? reference;

  Anket.fromMap(dynamic map, {this.reference})
      : assert(map["isim"] != null),
        // gelen isim ve oy ların boş olmaması
        //durumunda mapler
        assert(map["oy"] != null),
        isim = map["isim"],
        oy = map["oy"];

  Anket.fromSapshot(DocumentSnapshot? snapshot)
      : this.fromMap(snapshot?.data(), reference: snapshot?.reference);

  @override
  String toString() => "Kayıt <$isim : $oy>";
}
