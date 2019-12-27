import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_pocket_personal_trainer/datas/exercise_data.dart';
import 'package:mini_pocket_personal_trainer/tiles/exercise_tile.dart';

class CategoryScreen extends StatelessWidget {
  final DocumentSnapshot _doc;

  CategoryScreen(this._doc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_doc.data["title"]),
          centerTitle: true,
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance
              .collection("exercicios")
              .document(_doc.documentID)
              .collection("itens")
              .getDocuments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: Container(
                  width: 100,
                  height: 100,
                  child: FlareActor(
                    'assets/animations/WeightSpin.flr',
                    animation: 'Spin',
                  ),
                ),
              );

            print(snapshot.data.documents.length);
            return ListView.builder(
                padding: EdgeInsets.all(4.0),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  ExerciseData exercise;
                  exercise =
                      ExerciseData.fromDocument(snapshot.data.documents[index]);
                  exercise.category = _doc.data["title"];
                  print(exercise.toResumeMap());
                  return ExerciseTile(exercise);
                });
          },
        ));
  }
}
