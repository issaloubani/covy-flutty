import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PlaceholderBox extends StatelessWidget {
  final int height;

  const PlaceholderBox({Key key, @required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
            height: 250.0,
            child: Shimmer.fromColors(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.grey[400],
                ),
              ),
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[350],
              direction: ShimmerDirection.ltr,
            )),
      ),
    );
  }
}