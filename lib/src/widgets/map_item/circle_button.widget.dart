import 'package:cuchi/styles/theme.dart';
import 'package:flutter/material.dart';

class CircleButtonMapWidget extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData icon;

  const CircleButtonMapWidget({Key key, this.onTap, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LightTheme.gradient,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      width: 35,
      height: 35,
      child: GestureDetector(
        onTap: this.onTap,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
          child: Icon(
            this.icon,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
