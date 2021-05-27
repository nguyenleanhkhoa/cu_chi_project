import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cuchi/global_constant.dart';
import 'package:cuchi/src/bloc/bloc.g.dart';
import 'package:cuchi/src/dto/dto.dart';
import 'package:cuchi/src/model/models.dart';

import 'package:cuchi/src/utils/UtilsCommon.dart';
import 'package:cuchi/src/widgets/widgets.dart';

import 'package:cuchi/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screen.dart';
import 'map_overview_detail.screen.dart';

class DetailPlaceScreen extends StatefulWidget {
  static const routeName = "/detail-place-copy";
  @override
  _DetailPlaceScreenState createState() => _DetailPlaceScreenState();
}

class _DetailPlaceScreenState extends State<DetailPlaceScreen>
    with AutomaticKeepAliveClientMixin {
  var top = 0.0;

  DetailPlaceBloc detailPlaceBloc;

  DetailPlaceScreenDto detailPlaceData;

  ButtonIntDetailBloc _buttonIntDetailBloc;

  MapDetailBloc mapDetailBloc;

  LatLng latLngPostion = LatLng(11.018212, 106.508490);

  bool notNull(Object o) => o != null;

  bool saveShare = false;
  bool moreInfor = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> setValueToSharePreference(String key, String value) async {
    assert(value.isEmpty == false);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  List<PlaceShareModel> listPlaceLocation = [];

  List<String> listLocationHistory = [];

  Future<void> onRetreiveData(PlaceShareModel placeLocationModel,
      BuildContext context, ButtonIntDetailBloc _buttonIntDetailBloc) async {
    var pref = await SharedPreferences.getInstance();
    List<String> listHisTmp = pref.getStringList("listPlace");
    if (listHisTmp != null && listHisTmp.length != 0) {
      final itemExist = listHisTmp.where((element) =>
          PlaceShareModel.fromJson(jsonDecode(element)).name ==
          placeLocationModel.name);
      if (itemExist.length == 0) {
        listHisTmp.insert(0, jsonEncode(placeLocationModel));
        saveShare = true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Lưu thành công ${placeLocationModel.name}'),
          action: SnackBarAction(
            label: 'Hoàn tác',
            onPressed: () {
              removeItemPlaceHistory(
                  PlaceShareModel(
                    id: placeLocationModel.id,
                    point: Point(
                        lat: placeLocationModel.point.lat,
                        lng: placeLocationModel.point.lng),
                    type: placeLocationModel.type,
                    name: placeLocationModel.name,
                  ),
                  context,
                  _buttonIntDetailBloc);
            },
          ),
        ));
      }

      listLocationHistory = listHisTmp;
    } else {
      listLocationHistory.add(jsonEncode(placeLocationModel));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Lưu thành công ${placeLocationModel.name}'),
        action: SnackBarAction(
          label: 'Hoàn tác',
          onPressed: () {
            removeItemPlaceHistory(
                PlaceShareModel(
                  id: placeLocationModel.id,
                  point: Point(
                      lat: placeLocationModel.point.lat,
                      lng: placeLocationModel.point.lng),
                  type: placeLocationModel.type,
                  name: placeLocationModel.name,
                ),
                context,
                _buttonIntDetailBloc);
          },
        ),
      ));
    }
    checkSaveShare(placeLocationModel.id, _buttonIntDetailBloc);

    pref.setStringList("listPlace", listLocationHistory);
  }

  Future<void> checkSaveShare(int id, ButtonIntDetailBloc detailBloc) async {
    var pref = await SharedPreferences.getInstance();
    List<String> listHisTmp = pref.getStringList("listPlace");
    if (listHisTmp != null && listHisTmp.length != 0) {
      final itemExist = listHisTmp.where(
          (element) => PlaceShareModel.fromJson(jsonDecode(element)).id == id);
      if (itemExist.length == 0) {
        detailBloc.add(ChangeTextEvent(false));
        saveShare = false;
      } else {
        detailBloc.add(ChangeTextEvent(true));
        saveShare = true;
      }
    } else {
      detailBloc.add(ChangeTextEvent(false));
      saveShare = false;
    }
  }

  Future<void> removeItemPlaceHistory(PlaceShareModel placeLocationModel,
      BuildContext context, ButtonIntDetailBloc buttonIntDetailBloc) async {
    var pref = await SharedPreferences.getInstance();
    final listHis = pref.getStringList("listPlace");

    if (listHis != null && listHis.length != 0) {
      listPlaceLocation = [];
      for (var item in listHis) {
        PlaceShareModel pl = PlaceShareModel.fromJson(jsonDecode(item));
        listPlaceLocation.add(pl);
      }
      var res = listPlaceLocation
          .where((element) => element.name == placeLocationModel.name);
      if (res.length == 1) {
        listPlaceLocation
            .removeWhere((element) => element.name == placeLocationModel.name);
        pref.remove("listPlace");
        listLocationHistory = [];
        for (var item in listPlaceLocation) {
          listLocationHistory.add(jsonEncode(item));
        }
        pref.setStringList("listPlace", listLocationHistory);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Đã xoá ${placeLocationModel.name}'),
          action: SnackBarAction(
            label: 'Hoàn tác',
            onPressed: () {
              onRetreiveData(
                  PlaceShareModel(
                    id: placeLocationModel.id,
                    point: Point(
                        lat: placeLocationModel.point.lat,
                        lng: placeLocationModel.point.lng),
                    type: placeLocationModel.type,
                    name: placeLocationModel.name,
                  ),
                  context,
                  buttonIntDetailBloc);
            },
          ),
        ));
        saveShare = false;

        checkSaveShare(placeLocationModel.id, buttonIntDetailBloc);
      }
    }
  }

  void locatePosition() async {
    try {
      latLngPostion = LatLng(11.144777, 106.462759);
    } catch (error) {
      print("GPS not support in emulator");
    }
  }

  void backToDirection(DetailPlaceScreenDto detailPlaceData) {
    // var placeLocation = PlaceLocationModel(
    //     name: detailPlaceData.name,
    //     point: Point(
    //         lat: detailPlaceData.point.lat, lng: detailPlaceData.point.lng),
    //     id: detailPlaceData.id,
    //     pinLocation: true,
    //     index: 0);
    // Navigator.of(context).pushReplacementNamed(MapOverviewScreen.routeName,
    //     arguments: placeLocation);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => MapOverviewScreen()));
  }

  final bloc = BaseObserver();

  Future<void> checkCurrent(
      BuildContext context, DetailPlaceState state) async {
    // bloc.loading();
    // CurrentPositionDto currentPositionDto =
    //     await GoogleMapUtils.getCurrentPosition();
    // Navigator.of(context).pop();
    // if (!currentPositionDto.isCurrentValid) {
    //   bloc.error(message: AppString.ALERT_MESSAGE_CHECK_LOCATION);
    // } else {

    // }
    PlaceLocationModel placeLocationModel = PlaceLocationModel(
      id: state.detailPlaceContent.id,
      name: state.detailPlaceContent.name,
      point: Point(
        lat: state.detailPlaceContent.point.lat,
        lng: state.detailPlaceContent.point.lng,
      ),
      isDestination: true,
      pinLocation: true,
    );
    // Navigator.of(context).pushNamed(MapOverviewDetail.routeName,
    //     arguments: ParamMapDetail(
    //         paramRequest: ParamRequest(
    //             id: 0,
    //             type: "value",
    //             idPlace: state.detailPlaceContent.id,
    //             pointEnd: RouteLatlng(
    //                 isDestination: true,
    //                 lat: state.detailPlaceContent.point.lat,
    //                 lng: state.detailPlaceContent.point.lng,
    //                 name: state.detailPlaceContent.name)),
    //         type: 2));

    Navigator.of(context)
        .pushNamed(MapOverviewDetail.routeName, arguments: placeLocationModel);
  }

  @override
  void initState() {
    detailPlaceBloc = BlocProvider.of<DetailPlaceBloc>(context);
    _buttonIntDetailBloc = BlocProvider.of<ButtonIntDetailBloc>(context);
    mapDetailBloc = BlocProvider.of<MapDetailBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    PlaceDetailModel idPlace = ModalRoute.of(context).settings.arguments;
    detailPlaceBloc.add(LoadingGetDetailEvent(idPlace.id, idPlace.type));

    checkSaveShare(idPlace.id, _buttonIntDetailBloc);
    List _buildBody(DetailPlaceState state) {
      List<Widget> listItems = [];

      listItems.add(
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                // border:
                //     Border(bottom: BorderSide(color: Colors.black54)),
              ),
              padding:
                  EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detailPlaceData != null
                        ? detailPlaceData.name
                        : "Đang cập nhật",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.aspect_ratio_rounded,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(detailPlaceData.area == null
                          ? "Đang cập nhật"
                          : detailPlaceData.area.toString() +
                              " " +
                              UtilsCommon.convertType(detailPlaceData.type)),
                    ],
                  )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.black54),
                      bottom: BorderSide(color: Colors.black54))),
              padding:
                  EdgeInsets.only(left: 15, right: 25, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  detailPlaceData.type == "places"
                      ? Container(
                          child: Column(
                            children: [
                              CircleButtonMapWidget(
                                icon: Icons.directions,
                                onTap: () {
                                  // backToDirection(detailPlaceData);
                                  checkCurrent(context, state);
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Chỉ đường",
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ],
                          ),
                        )
                      : null,
                  renderSave(context, detailPlaceData, _buttonIntDetailBloc),
                  detailPlaceData.type == "places"
                      ? Container(
                          child: Column(
                            children: [
                              CircleButtonMapWidget(
                                icon: Icons.share_outlined,
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      ShareLocationScreen.routeName,
                                      arguments: detailPlaceData);
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Chia sẻ",
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ],
                          ),
                        )
                      : null,
                ].where(notNull).toList(),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Giới thiệu",
                        style: TextStyle(
                            fontSize: 16,
                            color: LightTheme.colorMain,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // _detailDescription(detailPlaceData),
                      DetailIntroduction(
                        detailPlaceData: detailPlaceData,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Hình ảnh",
                        style: TextStyle(
                            fontSize: 16,
                            color: LightTheme.colorMain,
                            fontWeight: FontWeight.bold),
                      ),
                      detailPlaceData.getAttachments.length > 0
                          ? Container(
                              child: GridView.builder(
                                shrinkWrap: true,
                                itemCount: detailPlaceData.attachments.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 4.0),
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PhotoViewScreen(
                                          initialIndex: index,
                                          listAttachments:
                                              detailPlaceData.attachments,
                                        ),
                                      ),
                                    ),

                                    // onTap: () =>
                                    //     Navigator.of(context).pushNamed(
                                    //   PhotoViewScreen.routeName,
                                    //   arguments: PhotoGalleryModel(
                                    //       listAttachments:
                                    //           detailPlaceData
                                    //               .attachments,
                                    //       currentIndex: detailPlaceData
                                    //           .attachments[index].id),
                                    // ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(urlApi +
                                              "/api/v1/attachments/download/" +
                                              detailPlaceData
                                                  .attachments[index].id
                                                  .toString()),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Container(
                              child: Text("Đang cập nhật hình ảnh"),
                            )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );

      return listItems;
    }

    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      body: BlocConsumer<DetailPlaceBloc, DetailPlaceState>(
          listener: (context, state) {
        if (state.isGetSuccess) {
          detailPlaceData = state.detailPlaceContent;
        }
      }, builder: (context, state) {
        if (state.isLoading) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          );
        } else if (state.isGetSuccess) {
          detailPlaceData = state.detailPlaceContent;
          int indexOfBracket = detailPlaceData.name.indexOf("(");
          String nameShort = "";
          if (indexOfBracket > 0) {
            nameShort = detailPlaceData.name.substring(0, indexOfBracket);
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                  excludeHeaderSemantics: true,
                  pinned: true,
                  snap: false,
                  floating: true,
                  expandedHeight: 200.0,
                  elevation: 50,
                  backgroundColor: LightTheme.colorMain,
                  flexibleSpace: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    top = constraints.biggest.height;
                    return FlexibleSpaceBar(
                      centerTitle: true,
                      title: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: 1.0,
                        child: Text(
                          detailPlaceData != null
                              ? (nameShort != "")
                                  ? nameShort
                                  : detailPlaceData.name
                              : "Đang cập nhật",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                top < 105.0 ? Colors.white : Colors.transparent,
                          ),
                        ),
                      ),
                      background: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: urlApi +
                            "/api/v1/attachments/download/" +
                            detailPlaceData.attachments[0].id.toString(),
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Container(
                            color: Colors.black12, child: Icon(Icons.warning)),
                      ),
                    );
                  })),
              SliverList(
                  delegate: new SliverChildListDelegate(_buildBody(state))),
            ],
          );
        }
        return const SizedBox();
      }),
    );
  }

  Widget renderSave(BuildContext context, DetailPlaceScreenDto detailPlaceData,
      ButtonIntDetailBloc buttonIntDetailBloc) {
    String textSave = "Lưu";
    return BlocBuilder<ButtonIntDetailBloc, ButtonIntDetailState>(
      buildWhen: (oldState, currentState) {
        if (currentState is ButtonIntDetailInitial) {
          return false;
        }
        return true;
      },
      builder: (context, state) {
        if (state is ChangeTextState) {
          textSave = state.text;
        } else if (state is ButtonIntDetailInitial) {
          textSave = "Lưu";
        }
        return Container(
          child: Column(
            children: [
              CircleButtonMapWidget(
                icon: Icons.bookmark_outline,
                onTap: () {
                  if (saveShare) {
                    removeItemPlaceHistory(
                        PlaceShareModel(
                          id: detailPlaceData.id,
                          point: Point(
                              lat: detailPlaceData.point.lat,
                              lng: detailPlaceData.point.lng),
                          type: detailPlaceData.type,
                          name: detailPlaceData.name,
                        ),
                        context,
                        buttonIntDetailBloc);
                  } else {
                    onRetreiveData(
                        PlaceShareModel(
                          id: detailPlaceData.id,
                          point: Point(
                              lat: detailPlaceData.point.lat,
                              lng: detailPlaceData.point.lng),
                          type: detailPlaceData.type,
                          name: detailPlaceData.name,
                        ),
                        context,
                        buttonIntDetailBloc);
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                textSave,
                style: Theme.of(context).textTheme.headline3,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class DetailIntroduction extends StatefulWidget {
  final DetailPlaceScreenDto detailPlaceData;

  const DetailIntroduction({Key key, this.detailPlaceData}) : super(key: key);
  @override
  _DetailIntroductionState createState() => _DetailIntroductionState();
}

class _DetailIntroductionState extends State<DetailIntroduction> {
  bool isExpanded = false;
  double heightContent = 0.0;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(builder: (BuildContext context, constrant) {
        print(constrant.maxHeight);
        heightContent = constrant.biggest.height;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.detailPlaceData.description,
              overflow: TextOverflow.fade,
              maxLines: !isExpanded ? 10 : null,
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Text(
                      (!isExpanded) ? "Xem thêm" : "Thu gọn",
                      style: TextStyle(color: LightTheme.colorMain),
                    )),
              ],
            )
          ],
        );
      }),
    );
  }
}
