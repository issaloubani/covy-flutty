import 'package:covid_tracker_app/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class TipDialog extends StatefulWidget {
  TipDialog({Key key}) : super(key: key);

  @override
  _TipDialogState createState() => _TipDialogState();
}

class _TipDialogState extends State<TipDialog> {
  LottieBuilder animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animation = LottieBuilder.asset(
      Res.wear_anim,
      frameRate: FrameRate(60),
      fit: BoxFit.fill,
      onLoaded: (compositions) {

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Material(
                    borderRadius: BorderRadius.circular(
                      30.0,
                    ),
                    child: IconButton(
                      splashRadius: 30.0,
                      icon: Icon(Icons.close),
                      tooltip: "close",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 10.0, right: 15.0)),
                SvgPicture.asset(
                  Res.tip,
                  height: 24,
                ),
                Padding(padding: EdgeInsets.only(right: 15.0)),
                Text(
                  "Tip of the day",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      fontSize: 24),
                )
              ]),
          animation,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Masks",
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  fontSize: 24),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 5.0)),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Always Wear a mask when going out",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black54,
                  fontSize: 19),
            ),
          ),
          Padding(padding: EdgeInsets.all(15.30)),
          OutlineButton(
            onPressed: () => Navigator.pop(context),
            color: Colors.lightGreen,
            child: Text("Okay",
                style: TextStyle(
                    fontWeight: FontWeight.w800, color: Colors.green)),
          )
        ],
      ),
    );
  }
}
