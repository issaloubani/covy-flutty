import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TipPage extends StatelessWidget {
  final String animation;
  final String title;
  final String description;
  final String buttonText;

  const TipPage(
      {Key key,
      @required this.animation,
      @required this.title,
      @required this.description,
      @required this.buttonText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Lottie.asset(
            animation,
            frameRate: FrameRate(60),
          ),
          Expanded(
            child: Container(
              child: Column(children: [
                Text(title, style: Theme.of(context).textTheme.headline4),
                SizedBox(height: 5,),
                Container(width: MediaQuery.of(context).size.width - 80,child: Text(description,textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6)),
                SizedBox(height: 20,),
                RaisedButton(
                  splashColor: Colors.green[300],
                  color: Colors.green,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(buttonText,
                      style: Theme.of(context).accentTextTheme.button),
                )
              ]),
            ),
          )
          /*      Expanded(
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    30.0,
                  ),
                  topRight: Radius.circular(
                    30.0,
                  )),
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 10),
                          color: Colors.grey[200],
                          blurRadius: 20,
                        )
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            30.0,
                          ),
                          topRight: Radius.circular(
                            30.0,
                          )),
                      color: Colors.white),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(title,
                            style: TextStyle(
                              fontWeight: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .fontWeight,
                              fontSize: 27,
                            )),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: MediaQuery.of(context).size.width - 80,
                            child: Text(description,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .fontWeight,
                                  color: Colors.black87,
                                  fontSize: 27,
                                )),
                          ),
                        ),
                        RaisedButton(
                          splashColor: Colors.green[300],
                          color: Colors.green,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(buttonText,
                              style: Theme.of(context).accentTextTheme.button),
                        )
                      ])),
            ),
          )*/
        ],
      ),
    ));
  }
}
