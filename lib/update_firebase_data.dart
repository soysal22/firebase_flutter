// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateFirebaseData extends StatefulWidget {
  const UpdateFirebaseData({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UpdateFirebaseDataState createState() => _UpdateFirebaseDataState();
}

class _UpdateFirebaseDataState extends State<UpdateFirebaseData> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('dilanketi').snapshots(),
      // fire base bağlantısını yaptık
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LinearProgressIndicator();
        } else {
          return _buildbodyItem(context, snapshot.data!.docs);
        }
      },
    );
  }

  Widget _buildbodyItem(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20),
      children: snapshot
          .map<Widget>((data) => _buildListItem(context, data))
          .toList(),
    );
  }

  _buildListItem(BuildContext context, DocumentSnapshot data) {
    final kayit = Anket.fromSnapshot(data);

    return Padding(
        key: ValueKey(kayit.isim),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            title: Text(kayit.isim.toString()),
            trailing: Text(kayit.oy.toString()),
            onTap: () => kayit.reference?.update({
              'oy': kayit.oy! + 1
            }), // hangi listedeki die dokunursa arka planda güncelleme  yapmamızı sağlıyor
          ),
        ));
  }
}

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

  Anket.fromSnapshot(DocumentSnapshot? snapshot)
      : this.fromMap(snapshot?.data(), reference: snapshot?.reference);

  @override
  String toString() => "Kayıt <$isim : $oy>";
}
