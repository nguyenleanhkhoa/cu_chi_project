import 'dart:convert';

import 'package:cuchi/src/bloc/bloc.g.dart';
import 'package:cuchi/src/datas/data_morkup.dart';
import 'package:cuchi/src/model/models.dart';

import 'package:cuchi/src/widgets/widgets.dart';

import 'package:cuchi/styles/theme.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../screen.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  TabBarTypeBloc tabBarTypeBloc;
  ListLocationBloc listLocationBloc;
  List<PlaceListPoinModel> listPlace = [];
  ListLocationHistoryBloc listLocationHistoryBloc;
  Result data;
  bool loadmore = true;
  bool showLoadMore = true;
  var textEditingController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var dataReceived;

  List<String> listItemSelected = [];
  List<Widget> renderListTabWidget() {
    List<Widget> listRdbtn = [];
    for (var item in Data.listTab) {
      listRdbtn.add(TabBarTypeWidget(
        iconPath: item['image_icon'],
        color: Colors.white,
        text: item["label"],
        checked: item["checked"],
      ));
    }
    return listRdbtn;
  }

  List<String> listLocationHistory = [];

  List<PlaceLocationModel> listPlaceLocation = [];

  // Save value to history list and pass data to timeline input
  Future<void> onRetreiveData(PlaceLocationModel placeLocationModel) async {
    var pref = await SharedPreferences.getInstance();
    List<String> listHisTmp = pref.getStringList("listHis");
    if (listHisTmp != null && listHisTmp.length != 0) {
      final itemExist = listHisTmp.where((element) =>
          PlaceLocationModel.fromJson(jsonDecode(element)).id ==
          placeLocationModel.id);
      if (itemExist.length == 0) {
        listHisTmp.insert(0, jsonEncode(placeLocationModel));
      }

      listLocationHistory = listHisTmp;
    } else {
      listLocationHistory.add(jsonEncode(placeLocationModel));
    }

    pref.setStringList("listHis", listLocationHistory);

    Navigator.of(context).pop(placeLocationModel);
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

  // init list history
  Future<void> getValueSharePreference() async {
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

  Future<void> clearAllHistory() async {
    var pref = await SharedPreferences.getInstance();
    pref.remove("listHis");
    listPlaceLocation = [];
    listLocationHistoryBloc.add(ShowHistoryLocationEvent([]));
  }

  @override
  void initState() {
    listLocationBloc = BlocProvider.of<ListLocationBloc>(context);
    listLocationHistoryBloc = BlocProvider.of<ListLocationHistoryBloc>(context);
    tabBarTypeBloc = BlocProvider.of<TabBarTypeBloc>(context);
    getValueSharePreference();
    listLocationBloc.add(InitSearchLocationEvent());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    textEditingController = TextEditingController();
    dataReceived = ModalRoute.of(context).settings.arguments;
    listPlace = [];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              toolInputLocation(),
              historyList(),
              resultList(),
            ].where((element) => element != null).toList(),
          ),
        ),
      ),
    );
  }

  Widget toolInputLocation() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black26),
                color: Colors.white,
                borderRadius: BorderRadius.circular(30)),
            child: Row(
              children: [
                const SizedBox(
                  width: 10.0,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    color: Colors.transparent,
                    child:
                        Icon(Icons.chevron_left, color: LightTheme.colorMain),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 13),
                      hintText: 'Thêm địa điểm ?',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 0, left: 10),
                    ),
                    onSubmitted: (value) {
                      listLocationBloc
                          .add(SearchLocationEvent(value, false, 0));
                      listLocationHistoryBloc.add(CloseHistoryLocationEvent());
                    },
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        listLocationBloc.add(SearchLocationEvent(
                            textEditingController.text, false, 0));
                        listLocationHistoryBloc
                            .add(CloseHistoryLocationEvent());
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Icon(
                          Icons.search,
                          color: LightTheme.colorMain,
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          color: Colors.grey[100],
          height: 10.0,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          padding: EdgeInsets.only(left: 15),
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  (dataReceived == 0
                      ? GestureDetector(
                          onTap: () {
                            var placeLocation = PlaceLocationModel(
                                name: "Vị trí hiện tại",
                                point: Point(lat: 11.141487, lng: 106.463796),
                                id: 0,
                                pinLocation: false,
                                index: dataReceived);
                            Navigator.of(context).pop(placeLocation);
                          },
                          child: Row(
                            children: [
                              Container(
                                  width: 25.0,
                                  height: 25.0,
                                  decoration: BoxDecoration(
                                      color: LightTheme.colorMain,
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  child: Icon(
                                    Icons.gps_fixed,
                                    color: Colors.white,
                                    size: 15.0,
                                  )),
                              SizedBox(
                                width: 15,
                              ),
                              const Text(
                                "Vị trí hiện tại",
                                style: TextStyle(fontSize: 15),
                              )
                            ],
                          ),
                        )
                      : null)
                ].where((element) => element != null).toList(),
              ),
              (dataReceived == 0
                  ? Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Container(
                            height: 1.0,
                            width: MediaQuery.of(context).size.width * 0.8,
                            color: Colors.grey[300],
                          ),
                        )
                      ],
                    )
                  : Container(
                      width: 0.0,
                      height: 0.0,
                    )),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  // onRetreiveData(placeLocation);
                  Navigator.of(context)
                      .pushNamed(GoogleMapPinLocationScreen.routeName)
                      .then((position) {
                    if (position != null) {
                      var pos = position as PlaceLocationModel;

                      var placeLocation = PlaceLocationModel(
                          name: pos.name,
                          point: Point(lat: pos.point.lat, lng: pos.point.lng),
                          id: pos.id,
                          pinLocation: true,
                          index: dataReceived);
                      onRetreiveData(placeLocation);
                    }
                  });
                },
                child: Container(
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Container(
                              width: 25.0,
                              height: 25.0,
                              decoration: BoxDecoration(
                                  color: LightTheme.colorMain,
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Icon(
                                Icons.place,
                                color: Colors.white,
                                size: 15.0,
                              )),
                          SizedBox(
                            width: 15,
                          ),
                          const Text(
                            "Chọn địa điểm",
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          color: Colors.grey[100],
          height: 10.0,
          width: MediaQuery.of(context).size.width,
        )
      ],
    );
  }

  Widget historyList() {
    return BlocBuilder<ListLocationHistoryBloc, ListLocationHistoryState>(
      builder: (context, state) {
        if (state is ShowHistoryLocationState) {
          return Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 50.0,
                        padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Lịch sử",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: LightTheme.colorMain),
                            ),
                          ],
                        ),
                      ),
                      listPlaceLocation.length != 0
                          ? GestureDetector(
                              onTap: () {
                                clearAllHistory();
                              },
                              child: Container(
                                height: 50.0,
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, top: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
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
                            )
                          : SizedBox(width: 0.0, height: 0.0),
                    ],
                  ),
                  listPlaceLocation.length != 0
                      ? Expanded(
                          child: ListView.builder(
                              itemCount: listPlaceLocation.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (dataReceived != null) {
                                        listPlaceLocation[index].index =
                                            dataReceived;
                                        onRetreiveData(
                                            listPlaceLocation[index]);
                                      } else {
                                        onRetreiveData(
                                            listPlaceLocation[index]);
                                      }
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
                                                width: 30.0,
                                                height: 30.0,
                                                decoration: BoxDecoration(
                                                    color: LightTheme.colorMain,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0)),
                                                child: Icon(
                                                  Icons.history,
                                                  color: Colors.white,
                                                  size: 20.0,
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
                                                  removeItemPlaceHistory(index);
                                                },
                                                child: Icon(
                                                  Icons.clear,
                                                  color: LightTheme.colorMain,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            color: Colors.white,
                            padding: EdgeInsets.only(top: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [Text("Không có lịch sử được lưu!")],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        }
        return Container(
          width: 0.0,
          height: 0.0,
        );
      },
    );
  }

  Widget resultList() {
    return BlocConsumer<ListLocationBloc, ListLocationState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ListLocationInitial) {
          listPlace = [];
        } else if (state is LoadSuccessSearchLocationState) {
          //listPlace = state.listPlace;
          listPlace = [];
          data = state.listPlace;
          listPlace.addAll(data.result);
        } else if (state is LoadFailedSearchLocationState) {
          //show error
        } else if (state is LoadMoreSearchLocationState) {
          textEditingController.clear();
          data = state.listPlace;
          listPlace.addAll(data.result);
          if (state.listPlace.result.length == 0) {
            showLoadMore = false;
          } else {
            showLoadMore = true;
          }
        }
        if (listPlace.length == 0) {
          return Container();
        }
        return Expanded(
          child: listPlace.length != 0
              ? Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Kết quả",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: LightTheme.colorMain),
                          ),
                          // Text("Xóa toàn bộ")
                        ],
                      ),
                    ),
                    Flexible(
                      child: ListView.builder(
                          itemCount: listPlace.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                if (dataReceived != null) {
                                  var placeLocation = PlaceLocationModel(
                                      name: listPlace[index].name,
                                      point: Point(
                                          lat: listPlace[index].points[0].lat,
                                          lng: listPlace[index].points[0].lng),
                                      id: listPlace[index].id,
                                      pinLocation: false,
                                      index: dataReceived);
                                  onRetreiveData(placeLocation);
                                } else {
                                  var placeLocation = PlaceLocationModel(
                                      name: listPlace[index].name,
                                      point: Point(
                                          lat: listPlace[index].points[0].lat,
                                          lng: listPlace[index].points[0].lng),
                                      id: listPlace[index].id,
                                      pinLocation: false,
                                      index: -1);
                                  onRetreiveData(placeLocation);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                                                color: LightTheme.colorMain,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30.0)),
                                            child: Icon(
                                              Icons.place_outlined,
                                              color: Colors.white,
                                              size: 15.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 10,
                                      child: ListTile(
                                        title: Text(
                                          listPlace[index].name,
                                          textScaleFactor: 1,
                                        ),
                                        subtitle: Text(listPlace[index]
                                                .points[0]
                                                .lat
                                                .toString() +
                                            ',' +
                                            listPlace[index]
                                                .points[0]
                                                .lng
                                                .toString()),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    (showLoadMore
                        ? GestureDetector(
                            onTap: () {
                              listLocationBloc.add(SearchLocationEvent(
                                  textEditingController.text ?? "",
                                  true,
                                  listPlace.length));
                            },
                            child: Container(
                              height: 30.0,
                              child: Center(
                                child: Text(
                                  "Hiển thị thêm",
                                  style: TextStyle(
                                      color: LightTheme.colorMain,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        : null),
                  ].where((element) => element != null).toList(),
                )
              : Container(),
        );
      },
    );
  }
}
