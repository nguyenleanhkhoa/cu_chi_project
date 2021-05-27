import 'package:cuchi/src/dto/dto.dart';
import 'package:cuchi/src/model/models.dart';
import 'package:cuchi/src/screens/view/map_overview_detail.screen.dart';
import 'package:cuchi/src/utils/resources/global_string.resource.dart';
import 'package:cuchi/src/widgets/widgets.dart';

import 'package:cuchi/styles/theme.dart';
import 'package:flutter/material.dart';

class NearByLocationScreen extends StatefulWidget {
  static const routeName = "/near-by-location";

  @override
  _NearByLocationScreenState createState() => _NearByLocationScreenState();
}

class _NearByLocationScreenState extends State<NearByLocationScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void locatePosition() async {
    //  showDialog(
    //       barrierDismissible: false,
    //       context: context,
    //       builder: (_) => AlertDialogMessage(
    //             isLoading: true,
    //           ));
    //   bool isValid = await GoogleMapUtils.checkCurrentLocationIsValid(context: this.context);
    //   Navigator.of(context).pop();

    //   PositionDto position = await GoogleMapUtils.getCurrentPosition(context: this.context);
    //   currentPosition = PositionDto(lat: position.lat, lng: position.lng);
    //   UtilsCommon.showSnackBarAlert(
    //       context: this.context,
    //       message: currentPosition.lat.toString() +
    //           " : " +
    //           currentPosition.lng.toString());
    //   if (!isValid) {
    //     showDialog(
    //         context: context,
    //         builder: (_) => AlertDialogMessage(
    //               subscription: AppString.ALERT_MESSAGE_CHECK_LOCATION,
    //               isError: true,
    //               isShowButtonAction: true,
    //             ));
    //   }
    //   try {
    //     targetTmp = LatLng(position.lat, position.lng);

    //     _googleMapcontroller.myLocationEnabled = true;

    //     _googleMapcontroller.animateCamera(CameraUpdate.newCameraPosition(
    //         new CameraPosition(target: targetTmp, zoom: 15.5)));
    //   } catch (error) {
    //     showDialog(
    //         context: context,
    //         builder: (_) => AlertDialogMessage(
    //               subscription: AppString.GPS_NOT_SUPPORT_PLATFORM,
    //               isError: true,
    //               isShowButtonAction: true,
    //             ));
    //   }
  }

  @override
  Widget build(BuildContext context) {
    List<PlaceAttachmentModel> listplace =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left,
            color: Colors.grey,
          ),
        ),
        elevation: 0.0,
        title: TitleGradientWidget(
          text: AppString.NEAR_BY_PLACE,
          gradient: LightTheme.gradient,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: (MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top) *
                0.95,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    child: ListView.builder(
                        physics: new NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: listplace.length,
                        itemBuilder: (context, number) {
                          return ListTile(
                            title: Text(
                              listplace[number].name,
                              textScaleFactor: 1,
                            ),
                            trailing: CircleButtonMapWidget(
                              onTap: () {
                                // locatePosition();

                                Navigator.of(context).pushNamed(
                                    MapOverviewDetail.routeName,
                                    arguments: ParamMapDetail(
                                        paramRequest: ParamRequest(
                                            id: listplace[number].id,
                                            type: listplace[number].type,
                                            idPlace: 0),
                                        type: 1));
                                // Navigator.of(context).pushNamed(
                                //     MapOverviewDetail.routeName,
                                //     arguments: ParamMapDetail(
                                //         paramRequest: ParamRequest(
                                //             id: 0,
                                //             type: "value",
                                //             idPlace: listplace[number].id,
                                //             pointEnd: RouteLatlng(
                                //                 lat:
                                //                     listplace[number].point.lat,
                                //                 lng:
                                //                     listplace[number].point.lng,
                                //                 name: listplace[number].name)),
                                //         type: 2));
                              },
                              icon: Icons.directions,
                            ),
                            subtitle: Text(
                                listplace[number].point.lat.toString() +
                                    ", " +
                                    listplace[number].point.lng.toString()),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  MapOverviewDetail.routeName,
                                  arguments: ParamMapDetail(
                                      paramRequest: ParamRequest(
                                          id: listplace[number].id,
                                          type: listplace[number].type,
                                          idPlace: listplace[number].id,
                                          pointEnd: RouteLatlng(
                                              lat: listplace[number].point.lat,
                                              lng: listplace[number].point.lng,
                                              name: listplace[number].name)),
                                      type: 1));
                            },
                          );
                        }),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
