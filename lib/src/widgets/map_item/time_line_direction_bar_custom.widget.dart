import 'dart:convert';
import 'dart:core';
import 'dart:ui';

import 'package:cuchi/src/bloc/bloc.g.dart';
import 'package:cuchi/src/model/models.dart';
import 'package:cuchi/src/repository/google_map_respository/google_map.respository.dart';
import 'package:cuchi/src/screens/screen.dart';
import 'package:cuchi/src/utils/UtilsCommon.dart';
import 'package:cuchi/src/utils/resources/global_string.resource.dart';
import 'package:cuchi/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../widgets.dart';

class TimelineDirectionCustom extends StatefulWidget {
  Function isPinLocation;
  Function onRemoveItem;
  Function onRetrievedCurrentListTimeline;
  double currentLat;
  double currentLng;
  BuildContext context;

  TimelineDirectionCustom({
    Key key,
    this.isPinLocation,
    this.onRemoveItem,
    this.onRetrievedCurrentListTimeline,
    this.currentLat,
    this.currentLng,
    this.context,
  }) : super(key: key);

  @override
  _TimelineDirectionCustomState createState() =>
      _TimelineDirectionCustomState();
}

class _TimelineDirectionCustomState extends State<TimelineDirectionCustom>
    with TickerProviderStateMixin {
  MapBloc mapBloc;
  TimelineBarBloc timelineBarBloc;
  UserInforBloc userInforBloc;
  GoogleMapRepository googleMapRepository;
  MapDetailBloc mapDetailBloc;
  ListLocationHistoryBloc listLocationHistoryBloc;
  List<String> listLocationHistory = [];

  final data = [
    "#",
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];
  List<PlaceLocationModel> listPlaceLocation = [];

  List<PlaceLocationModel> listDirection = [
    PlaceLocationModel(
      name: AppString.CURRENT_LOCATION,
      point: Point(lat: 0.0, lng: 0.0),
      id: 0,
      isDestination: true,
      pinLocation: false,
    ),
    PlaceLocationModel(
      name: AppString.MORE_LOCATION,
      point: Point(lat: 0.0, lng: 0.0),
      id: -1,
      pinLocation: false,
    ),
  ];

  double heightCustom = 210.0;
  // declare animation
  Animation<double> timelineAnimation;
  AnimationController timelineAnimationController;
  // end declare animation

  // RefreshController _refreshController =
  //     RefreshController(initialRefresh: false);

  @override
  void initState() {
    mapBloc = BlocProvider.of<MapBloc>(context);
    mapDetailBloc = BlocProvider.of<MapDetailBloc>(context);
    timelineBarBloc = BlocProvider.of<TimelineBarBloc>(context);
    userInforBloc = BlocProvider.of<UserInforBloc>(context);
    listLocationHistoryBloc = BlocProvider.of<ListLocationHistoryBloc>(context);

    googleMapRepository = GoogleMapRepository();

    // timelineBarBloc.add(TimelineBarInitEvent());
    initAnimation();

    super.initState();
  }

  void initAnimation() {
    //init Animation
    timelineAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    timelineAnimation = Tween(begin: 0.0, end: heightCustom).animate(
        CurvedAnimation(
            parent: timelineAnimationController, curve: Curves.ease));
    // end init Animation
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void onAddMore() {
    Navigator.of(context).pushNamed(AddPlaceScreen.routeName).then((val) {
      userInforBloc.add(ShowUserInforEvent(false));
      if (val == null) {
        return;
      }

      var placeLocationModel = (val as PlaceLocationModel);
      placeLocationModel.isDestination = true;
      double heightTmp = heightCustom;
      setState(() {
        listDirection.insert(listDirection.length - 1, placeLocationModel);
        if (heightCustom < 226.0) {
          heightCustom += 55.0;
        }
        if (listDirection.length >= 8) {
          listDirection.removeLast();
        }
      });
      timelineAnimation = Tween(begin: heightTmp, end: heightCustom).animate(
          CurvedAnimation(
              parent: timelineAnimationController, curve: Curves.ease));
      timelineAnimationController.forward();
      getValueSharePreference();
    });
  }

  void showTimeline() {
    timelineAnimation = Tween(begin: 0.0, end: heightCustom).animate(
        CurvedAnimation(
            parent: timelineAnimationController, curve: Curves.ease));
    timelineAnimationController.forward();
  }

  void closeTimeline() {
    timelineAnimation = Tween(begin: 0.0, end: heightCustom).animate(
        CurvedAnimation(
            parent: timelineAnimationController, curve: Curves.ease));
    timelineAnimationController.reverse();
  }

  void onAddMoreFromHistoryList(PlaceLocationModel placeLocationModel) {
    placeLocationModel.isDestination = true;
    double heightTmp = heightCustom;

    setState(() {
      listDirection.insert(listDirection.length - 1, placeLocationModel);
      if (heightCustom < 265.0) {
        heightCustom += 55.0;
      }
      if (listDirection.length >= 8) {
        listDirection.removeLast();
      }
    });
    timelineAnimation = Tween(begin: heightTmp, end: heightCustom).animate(
        CurvedAnimation(
            parent: timelineAnimationController, curve: Curves.ease));
    timelineAnimationController.forward();
  }

  void onUpdateValueByIndex(ind, bool isLast) {
    Navigator.of(context)
        .pushNamed(AddPlaceScreen.routeName, arguments: ind)
        .then((value) {
      userInforBloc.add(ShowUserInforEvent(false));
      if (value == null) {
        return;
      }
      var placeLocationModel = (value as PlaceLocationModel);
      placeLocationModel.isDestination = true;
      setState(() {
        listDirection.removeAt(placeLocationModel.index);
        listDirection.insert(placeLocationModel.index, placeLocationModel);

        if (!isLast) {
          if (listDirection.length < 8) {
            listDirection.add(
              PlaceLocationModel(
                name: AppString.MORE_LOCATION,
                point: Point(lat: 0.0, lng: 0.0),
                id: -1,
                pinLocation: false,
              ),
            );
          }
        }
      });
      getValueSharePreference();
    });
  }

  void onRemoveValueByIndex(ind) {
    double heightTmp = heightCustom;

    setState(() {
      if (heightCustom > 210.0) {
        if (listDirection.length < 4) {
          heightCustom -= 55.0;
        }
      }
      if (listDirection.length > 1) {
        listDirection.removeAt(ind);
      }
    });
    timelineAnimation = Tween(begin: heightTmp, end: heightCustom).animate(
        CurvedAnimation(
            parent: timelineAnimationController, curve: Curves.ease));
    timelineAnimationController.forward();
  }

  // init list history
  Future<void> getValueSharePreference() async {
    listPlaceLocation = [];
    var pref = await SharedPreferences.getInstance();
    final listHis = pref.getStringList("listHis");
    if (listHis != null && listHis.length != 0) {
      for (var item in listHis) {
        PlaceLocationModel pl = PlaceLocationModel.fromJson(jsonDecode(item));
        listPlaceLocation.add(pl);
        if (listPlaceLocation.length > 10) {
          listPlaceLocation.removeAt(0);
        }
      }

      listLocationHistoryBloc.add(ShowHistoryLocationEvent(listPlaceLocation));
    }
  }

  Future<void> clearAllHistory() async {
    var pref = await SharedPreferences.getInstance();
    pref.remove("listHis");
    listPlaceLocation = [];
    listLocationHistoryBloc.add(ShowHistoryLocationEvent([]));
  }

  // remove item history
  Future<void> removeItemPlaceHistory(index) async {
    var pref = await SharedPreferences.getInstance();
    final listHis = pref.getStringList("listHis");

    if (listHis != null && listHis.length != 0) {
      listPlaceLocation = [];
      for (var item in listHis) {
        PlaceLocationModel pl = PlaceLocationModel.fromJson(jsonDecode(item));
        listPlaceLocation.add(pl);
      }
      if (listPlaceLocation.length > 10) {
        listPlaceLocation.removeAt(0);
      }
      listPlaceLocation.removeAt(index);

      onResetHistory(listPlaceLocation);
    }
  }

  void backToMainScreen(bool isSearchedRoute) {
    setState(() {
      timelineAnimation = Tween(begin: heightCustom, end: 200.0).animate(
          CurvedAnimation(
              parent: timelineAnimationController, curve: Curves.ease));
      timelineAnimationController.forward();
      heightCustom = 210.0;
      listDirection = [
        PlaceLocationModel(
          name: AppString.CURRENT_LOCATION,
          point: Point(lat: 11.143686, lng: 106.464185),
          id: 0,
          isDestination: true,
          pinLocation: false,
        ),
        PlaceLocationModel(
          name: AppString.MORE_LOCATION,
          point: Point(lat: 11.141487, lng: 106.463796),
          id: -1,
          pinLocation: false,
        ),
      ];
    });
    timelineBarBloc.add(CloseTimelineBarEvent(isSearchedRoute));
    listLocationHistoryBloc.add(CloseHistoryLocationEvent());
  }

  Future<void> onResetHistory(
      List<PlaceLocationModel> listPlaceLocationModel) async {
    var pref = await SharedPreferences.getInstance();
    pref.remove("listHis");
    listPlaceLocation = [];
    if (listPlaceLocationModel.length != 0) {
      listLocationHistory = [];

      for (var item in listPlaceLocationModel) {
        listLocationHistory.add(json.encode(item));
      }
      pref.setStringList("listHis", listLocationHistory);

      getValueSharePreference();
    } else {
      listLocationHistoryBloc.add(ShowHistoryLocationEvent(listPlaceLocation));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TimelineBarBloc, TimelineBarState>(
      listener: (context, state) {
        if (state is TimeLineBarSubmitedState) {
          print(state);
        }
        // else if (state is TimelineBarRetreivedLngLatState) {
        //   widget.currentLat = state.coordinate.lat;
        //   widget.currentLng = state.coordinate.lng;
        // }
        else if (state is TimelineBarShowState) {
          if (state.show) {
            getValueSharePreference();
          }
        }
      },
      buildWhen: (previous, current) {
        if (current is TimelineBarRetreivedLngLatState) {
          return false;
        } else if (current is TimelineBarInitial) {
          return false;
        } else if (current is TimelineBarShowState) {
          listDirection = [
            PlaceLocationModel(
              name: AppString.CURRENT_LOCATION,
              point: Point(lat: 11.143686, lng: 106.464185),
              id: 0,
              isDestination: true,
              pinLocation: false,
            ),
            PlaceLocationModel(
              name: AppString.MORE_LOCATION,
              point: Point(lat: 11.141487, lng: 106.463796),
              id: -1,
              pinLocation: false,
            ),
          ];
          if (!current.show) {
            mapBloc.add(LoaddingDefaultPolylineEvent(3));
            closeTimeline();
          } else {
            if (current.placeLocationModel != null) {
              listDirection.insert(1, current.placeLocationModel);
            }
            showTimeline();
          }
        } else if (current is TimelineBarInitial) {
          closeTimeline();
        } else if (current is TimelineBarClosedState) {
          // mapBloc.add(LoaddingDefaultPolylineEvent(3));
          if (current.isSearchedRoute) {
            mapBloc.add(ClosedTimeLineBarEvent(true));
          } else {
            mapBloc.add(ClosedTimeLineBarEvent(false));
          }
          closeTimeline();
        }

        return true;
      },
      builder: (context, state) {
        return Column(
          children: [
            AnimatedBuilder(
                animation: timelineAnimation,
                builder: (context, child) {
                  return Stack(
                    children: [
                      Container(
                        height: timelineAnimation.value,
                        padding: EdgeInsets.only(top: 40.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border(bottom: BorderSide(color: Colors.grey)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                color: Colors.white,
                                child: SingleChildScrollView(
                                  child: TimelineReorderList(
                                    listItem: listDirection,
                                    onSubmited: (value) {
                                      setState(() {
                                        listDirection = value;
                                      });
                                    },
                                    onAddMore: onAddMore,
                                    onUpdate: onUpdateValueByIndex,
                                    onRemove: onRemoveValueByIndex,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              top: BorderSide(
                                                  color: Colors.black12,
                                                  width: 1.0))),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      height: 40.0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          submitStreetBtn(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      timeLineBackButton(),
                    ],
                  );
                }),
            historyList(),
          ].where((element) => element != null).toList(),
        );
      },
    );
  }

  Widget submitStreetBtn() {
    if (widget.context.widget is MapOverviewDetail) {
      return TextButton(
        onPressed: () {
          mapDetailBloc.add(SearchStreetMapDetailRouteEvent(listDirection, 50));

          listLocationHistoryBloc.add(CloseHistoryLocationEvent());
        },
        child: Container(
          height: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          decoration: BoxDecoration(gradient: LightTheme.gradient),
          child: Center(
            child: Row(
              children: [
                Text(
                  "Tìm đường",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return TextButton(
      onPressed: () {
        mapBloc.add(SearchStreetMapRouteEvent(listDirection, 50));

        listLocationHistoryBloc.add(CloseHistoryLocationEvent());
      },
      child: Container(
        height: double.maxFinite,
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        decoration: BoxDecoration(gradient: LightTheme.gradient),
        child: Center(
          child: Row(
            children: [
              Text(
                "Tìm đường",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget timeLineNode(String val) {
    if (val == "#") {
      return TimelineTile(
        alignment: TimelineAlign.start,
        isFirst: (val == "#") ? true : false,
        isLast: (val == "*") ? true : false,
        indicatorStyle: IndicatorStyle(
          width: 30,
          indicatorXY: 0.5,
          drawGap: true,
          indicator: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(val),
            ),
          ),
        ),
      );
    } else if (val == "*") {
      return TimelineTile(
        alignment: TimelineAlign.start,
        isFirst: (val == "#") ? true : false,
        isLast: (val == "*") ? true : false,
        indicatorStyle: IndicatorStyle(
          width: 30,
          indicatorXY: 0.5,
          drawGap: true,
          indicator: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(val),
            ),
          ),
        ),
      );
    }
    return TimelineTile(
      alignment: TimelineAlign.start,
      isFirst: (val == "#") ? true : false,
      isLast: (val == "*") ? true : false,
      indicatorStyle: IndicatorStyle(
        width: 30,
        indicatorXY: 0.5,
        drawGap: true,
        indicator: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(val),
          ),
        ),
      ),
    );
  }

  Widget historyList() {
    return BlocConsumer<ListLocationHistoryBloc, ListLocationHistoryState>(
      listener: (context, state) {
        //
      },
      builder: (context, state) {
        if (state is CLoseHistoryLocationState) {
          return Expanded(
              child: Container(color: Colors.white, child: const SizedBox()));
        } else if (state is ShowHistoryLocationState) {
          return Expanded(
            child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 2.0, color: Colors.black12))),
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Lịch sử",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: LightTheme.colorMain),
                          ),
                          GestureDetector(
                            onTap: () {
                              clearAllHistory();
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Xoá toàn bộ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: LightTheme.colorMain),
                                ),
                                Icon(
                                  Icons.delete,
                                  color: LightTheme.colorMain,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    listPlaceLocation.length != 0
                        ? Expanded(
                            child: SizedBox(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: listPlaceLocation.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          onAddMoreFromHistoryList(
                                              listPlaceLocation[index]);
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 25.0,
                                                    height: 25.0,
                                                    decoration: BoxDecoration(
                                                        color: LightTheme
                                                            .colorMain,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    30.0)),
                                                    child: Icon(
                                                      Icons.history,
                                                      color: Colors.white,
                                                      size: 18.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 10,
                                              child: ListTile(
                                                title: Text(
                                                  listPlaceLocation[index].name,
                                                  textScaleFactor: 1,
                                                ),
                                                subtitle: Text(
                                                    listPlaceLocation[index]
                                                            .point
                                                            .lat
                                                            .toString() +
                                                        ',' +
                                                        listPlaceLocation[index]
                                                            .point
                                                            .lng
                                                            .toString()),
                                                trailing: GestureDetector(
                                                    onTap: () {
                                                      removeItemPlaceHistory(
                                                          index);
                                                    },
                                                    child: Icon(
                                                      Icons.clear,
                                                      color:
                                                          LightTheme.colorMain,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          )
                        : Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 300.0,
                              color: Colors.white,
                              padding: EdgeInsets.only(top: 10.0),
                              child: Column(
                                children: [Text(AppString.NONE_HISTORY)],
                              ),
                            ),
                          ),
                  ],
                )),
          );
        }
        return const SizedBox(
          width: 0.0,
          height: 0.0,
        );
      },
    );
  }

  Widget timeLineBackButton() {
    return Positioned(
        top: 50,
        left: 15,
        child: BlocBuilder<TimelineBarBloc, TimelineBarState>(
            builder: (context, state) {
          if (state is SearchRouteSuccessfullState) {
            return GestureDetector(
              onTap: () {
                backToMainScreen(true);
              },
              child: Container(
                child: Icon(
                  Icons.chevron_left,
                  size: 30,
                  color: Colors.grey[700],
                ),
              ),
            );
          }
          return GestureDetector(
            onTap: () {
              backToMainScreen(false);
            },
            child: Container(
              child: Icon(
                Icons.chevron_left,
                size: 30,
                color: Colors.grey[700],
              ),
            ),
          );
        }));
  }

  Widget inputDecorator(String item) {
    return Container(
      height: 40.0,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: Colors.grey[350],
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: TextField(
              obscureText: false,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10.0, top: -10.0),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent))),
              controller: new TextEditingController(
                text: UtilsCommon.removeBracketFirstAndLastString(item),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Icon(
              Icons.reorder,
              size: 20,
            ),
          )
        ],
      ),
    );
  }
}
