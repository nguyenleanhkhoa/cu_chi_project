import 'package:flutter/material.dart';

class TitleGradientWidget extends StatelessWidget {
  final String text;
  final Gradient gradient;
  final TextStyle style;

  const TitleGradientWidget({Key key, this.text, this.gradient, this.style})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: this.style),
    );
  }
}
