import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../res.dart';

class FlagAnimate extends StatefulWidget {
  final String image;
  final GestureTapCallback onTab;

  const FlagAnimate({Key key, @required this.image, @required this.onTab})
      : super(key: key);

  @override
  FlagAnimateState createState() => FlagAnimateState();
}

class FlagAnimateState extends State<FlagAnimate>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this, //
      duration: Duration(seconds: 1), // the SingleTickerProviderStateMixin
    );
    controller.animateTo(1);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTab,
      child: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              widget.image,
              height: 180,
            ),
            Lottie.asset(
              Res.click_anim,
              controller: controller,
              animate: false,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}
