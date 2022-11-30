// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable, await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TransactionsUpdateFirebaseData extends StatefulWidget {
  const TransactionsUpdateFirebaseData({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TransactionsUpdateFirebaseDataState createState() =>
      _TransactionsUpdateFirebaseDataState();
}

class _TransactionsUpdateFirebaseDataState
    extends State<TransactionsUpdateFirebaseData> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('dilanketi').snapshots(),
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
    final kayit = Anket.fromSapshot(data);

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
            onTap: () =>
                FirebaseFirestore.instance.runTransaction((transaction) async {
              // bu transactions kısmı olurda iki kullanıcı aynı anda listeye bsatıysa ikisinden biri aktif veya iptal etmeye yarar
              final FreshSnapshot = await transaction.get(kayit.reference!);

              final fresh = Anket.fromSapshot(
                  FreshSnapshot); // snapshot ı anket e  çevirdim
              await transaction.update(kayit.reference!, {'oy': fresh.oy! + 1});
            }),
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

  Anket.fromSapshot(DocumentSnapshot? snapshot)
      : this.fromMap(snapshot?.data(), reference: snapshot?.reference);

  @override
  String toString() => "Kayıt <$isim : $oy>";
}
