import 'package:cuchi/src/bloc/tool_bloc/zoom_in_out_bloc/zoom_in_out_bloc.dart';
import 'package:cuchi/src/model/models.dart';
import 'package:cuchi/src/widgets/unicorn_outline/unicorn_outline.widget.dart';
import 'package:cuchi/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_controller/google_maps_controller.dart';

class ZoomInOut extends StatelessWidget {
  GoogleMapsController googleMapcontroller;
  double zoomNumber = 0.0;
  LatLng target;
  var position;
  Function googleController;

  ZoomInOut({
    Key key,
    this.googleMapcontroller,
    this.zoomNumber,
    this.target,
  }) : super(key: key);

  void zoomIn(PositionDto position) async {
    if (zoomNumber < 22) {
      zoomNumber += 1.0;

      if (zoomNumber < 25.0) {
        LatLng latLngPostion = LatLng(position.lat, position.lng);
        target = latLngPostion;

        var current = new CameraPosition(target: target, zoom: zoomNumber);
        googleMapcontroller
            .animateCamera(CameraUpdate.newCameraPosition(current));
      }
    }
  }

  void zoomOut(PositionDto position) async {
    if (zoomNumber > 1) {
      zoomNumber -= 1.0;

      if (zoomNumber > 1.0) {
        LatLng latLngPostion = LatLng(position.lat, position.lng);
        target = latLngPostion;

        var current = new CameraPosition(target: target, zoom: zoomNumber);
        googleMapcontroller
            .animateCamera(CameraUpdate.newCameraPosition(current));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ZoomInOutBloc, ZoomInOutState>(
      builder: (context, state) {
        if (state is CurrentLngLatState) {
          position = PositionDto(lat: state.lat, lng: state.lng);
        }
        return Container(
          child: UnicornOutlineWidget(
            strokeWidth: 2,
            radius: 17,
            gradient: LightTheme.gradient,
            onPressed: () {},
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                  ),
                  width: 40,
                  height: 39,
                  child: GestureDetector(
                    onTap: () {
                      zoomIn(position);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: ShaderMask(
                        shaderCallback: (bounds) =>
                            LightTheme.gradient.createShader(
                          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Color.fromRGBO(255, 88, 71, 100),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  width: 40,
                  height: 39,
                  child: GestureDetector(
                    onTap: () {
                      zoomOut(position);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: Colors.orange[600],
                        )),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
