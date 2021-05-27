import 'package:cuchi/src/bloc/tool_bloc/map_navigator_bloc/map_navigator_bloc.dart';
import 'package:cuchi/src/utils/resources/image_string.resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_controller/google_maps_controller.dart';

class MapNavigatorWidget extends StatefulWidget {
  final GoogleMapsController googleMapcontroller;
  final CameraPosition currentPosition;
  final GestureTapCallback onTopPressed;
  final GestureTapCallback onLeftPressed;
  final GestureTapCallback onRightPressed;
  final GestureTapCallback onBottomPressed;

  const MapNavigatorWidget({
    Key key,
    this.googleMapcontroller,
    this.currentPosition,
    this.onTopPressed,
    this.onLeftPressed,
    this.onRightPressed,
    this.onBottomPressed,
  }) : super(key: key);

  @override
  _MapNavigatorWidgetState createState() => _MapNavigatorWidgetState();
}

class _MapNavigatorWidgetState extends State<MapNavigatorWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapNavigatorBloc, MapNavigatorState>(
      builder: (context, state) {
        if (!state.show) {
          return Container(
            width: 0.0,
            height: 0.0,
          );
        } else if (state is MapNavigatorInitial) {
          return SizedBox(
            width: 0.0,
            height: 0.0,
          );
        }
        return Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: 120.0,
                height: 120.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        widget.onLeftPressed();
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image: AssetImage(ImageString.NAVIGATE_LEFT_BUTTON),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // onNavigateTopClick();
                            widget.onTopPressed();
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image:
                                    AssetImage(ImageString.NAVIGATE_TOP_BUTTON),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // onNavigateBottomClick(
                            //     state.lat, state.lng, state.zoom);
                            widget.onBottomPressed();
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: AssetImage(
                                    ImageString.NAVIGATE_BOTTOM_BUTTON),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        // onNavigateRigthClick(state.lat, state.lng, state.zoom);
                        widget.onRightPressed();
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image:
                                AssetImage(ImageString.NAVIGATE_RIGHT_BUTTON),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
