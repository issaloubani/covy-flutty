import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final title;

  const TitleText({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ));
  }
}
