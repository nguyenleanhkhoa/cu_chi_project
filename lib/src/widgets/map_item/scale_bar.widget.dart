import 'package:cuchi/src/bloc/tool_bloc/scale_bar_bloc/scale_bar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_controller/google_maps_controller.dart';

class ScaleBarWidget extends StatelessWidget {
  String text;
  CameraPosition currentPos;

  ScaleBarWidget({Key key, this.text}) : super(key: key);
  var kilometerScale = 0.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScaleBarBloc, ScaleBarState>(
      builder: (context, state) {
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                child: Text(state is ScaleBarValueState ? state.scale : "0.0"),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              height: 8,
              width: 50,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: Colors.black),
                  left: BorderSide(width: 1, color: Colors.black),
                  right: BorderSide(width: 1, color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
          ],
        );
      },
    );
  }
}
