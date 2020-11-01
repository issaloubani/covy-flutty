import 'package:covid_tracker_app/ui/components/symptom_card.dart';
import 'package:flutter/material.dart';

import '../../res.dart';

class SymptomsList extends StatelessWidget {
  const SymptomsList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(5),
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SymptomCard(
                image: Res.fever,
                text: "Fever",
              ),
              SizedBox(
                width: 10,
              ),
              SymptomCard(
                image: Res.dizzy,
                text: "Dizzy",
              ),
              SizedBox(
                width: 10,
              ),
              SymptomCard(
                image: Res.cough,
                text: "Cough",
              ),
              SizedBox(
                width: 10,
              ),
              SymptomCard(
                image: Res.sneeze,
                text: "Sneeze",
              ),
              SizedBox(
                width: 10,
              ),
              SymptomCard(
                image: Res.sore_throat,
                text: "Sore throat",
              )
            ],
          ),
        ),
      ),
    );
  }
}
