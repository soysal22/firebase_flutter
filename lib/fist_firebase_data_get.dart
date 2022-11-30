// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(FirstFirebaseDataGet());
}

class FirstFirebaseDataGet extends StatelessWidget {
  FirstFirebaseDataGet({super.key});
  final Future<FirebaseApp> initalization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: initalization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Beklenilmeyen  bir hata oluştu "),
            );
          } else if (snapshot.hasData) {
            return const SurveyList();
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class SurveyList extends StatefulWidget {
  const SurveyList({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SurveyListState createState() => _SurveyListState();
}

class _SurveyListState extends State<SurveyList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('dilanketi').snapshots(),
        builder: (context, AsyncSnapshot asyncSnapshot) {
          return ListView(
            children: asyncSnapshot.data!.docs.map((DocumentSnapshot document) {
              return ListTile(
                title: Text(document['isim']),
                subtitle: Text(document['oy'].toString()),
              );
            }).toList(),
          );
        });
  }
}

final dummySnapshot = [
  {"isim": "Css", "oy": "5"},
  {"isim": "Java", "oy": "2"},
  {"isim": "Go", "oy": "0"},
  {"isim": "Python", "oy": "8"},
  {"isim": "C ", "oy": "10"},
  {"isim": "DArt", "oy": "1"},
  {"isim": "Sql", "oy": "9"},
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
}
