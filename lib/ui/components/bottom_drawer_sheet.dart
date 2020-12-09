import 'package:flutter/material.dart';

class BottomDrawerSheet extends StatelessWidget {
  const BottomDrawerSheet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DraggableScrollableSheet(
        initialChildSize: 0.2,
        minChildSize: 0.1,
        maxChildSize: 0.47,
        builder: (BuildContext context, _scrollController) {
          // return Container(
          //   decoration: ShapeDecoration(
          //       color: Colors.white,
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.only(
          //               topLeft: Radius.circular(30.0),
          //               topRight: Radius.circular(30.0)))),
          //   child: NotificationListener(
          //     onNotification: (OverscrollIndicatorNotification overscroll) {
          //       overscroll.disallowGlow();
          //       return;
          //     },
          //     child: SingleChildScrollView(
          //         controller: _scrollController,
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             DragHandler(),
          //             Flexible(
          //               child: DrawerPage(context),
          //             )
          //           ],
          //         )),
          //   ),
          // );

          return Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: Border.all(
                    color: Colors.red,
                    width: 8.0,
                  ) +
                  Border.all(
                    color: Colors.green,
                    width: 8.0,
                  ) +
                  Border.all(
                    color: Colors.blue,
                    width: 8.0,
                  ),
            ),
            child: Center(
              child: FlatButton(
                onPressed: () {
                  _scrollController.animateTo(10, duration: Duration(milliseconds: 500), curve: null);
                },
                child: Text("Click Me"),
              ),
            ),
          );
        },
      ),
    );
  }
}
