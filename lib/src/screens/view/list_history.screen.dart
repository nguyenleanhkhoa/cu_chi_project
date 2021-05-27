import 'dart:convert';

import 'package:cuchi/src/bloc/bloc.g.dart';
import 'package:cuchi/src/datas/data_morkup.dart';
import 'package:cuchi/src/model/models.dart';

import 'package:cuchi/src/utils/UtilsCommon.dart';
import 'package:cuchi/src/widgets/widgets.dart';

import 'package:cuchi/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screen.dart';
import 'detail_place.screen.dart';

class ListHistoryScreen extends StatefulWidget {
  static final String routeName = '/list-history-screen';

  @override
  _ListHistoryScreenState createState() => _ListHistoryScreenState();
}

class _ListHistoryScreenState extends State<ListHistoryScreen>
    with AutomaticKeepAliveClientMixin {
  List<PlaceListPoinModel> listPlace = [];
  List<PlaceListPoinModel> listTemp = [];
  TextEditingController textEditingController;

  SearchBloc searchBloc;

  MapBloc mapBloc;
  DetailMapBloc detailMapBloc;

  ButtonInSearchBloc buttonInSearchBloc;

  Result data;

  bool loadmore = false;

  bool showSearch = false;
  bool dataShare = false;
  String textHistory = "";

  bool showDelete = false;
  String textDataSearch = "";

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

// init list history
  Future<void> getValueSharePreference(SearchBloc searchBloc) async {
    var pref = await SharedPreferences.getInstance();
    final listHis = pref.getStringList("listPlace");
    listTemp = [];
    if (listHis != null && listHis.length != 0) {
      for (var item in listHis) {
        PlaceShareModel pl = PlaceShareModel.fromJson(jsonDecode(item));
        listTemp.add(PlaceListPoinModel(
            id: pl.id,
            name: pl.name,
            share: true,
            points: [Point(lat: pl.point.lat, lng: pl.point.lng)],
            type: pl.type));
      }

      final listHisSearch = pref.getStringList("listHis");
      if (listHisSearch != null && listHisSearch.length != 0) {
        for (var item in listHisSearch) {
          PlaceLocationModel pl = PlaceLocationModel.fromJson(jsonDecode(item));
          listTemp.add(PlaceListPoinModel(
              id: pl.id,
              name: pl.name,
              share: false,
              points: [Point(lat: pl.point.lat, lng: pl.point.lng)],
              type: "places"));
        }
      }
    }
    if (listTemp.length > 0) {
      searchBloc.add(BindingDataShareEvent(listTemp));
    }
  }

  Future<void> removeShare(SearchBloc searchBloc) async {
    var pref = await SharedPreferences.getInstance();
    pref.remove("listPlace");
    listTemp = [];
    searchBloc.add(BindingDataShareEvent(listTemp));
  }

  Future<void> _getRadius(SearchBloc searchBloc) async {
    final SharedPreferences prefs = await _prefs;
    final int radius = (prefs.getInt('radiusValue') ?? 0);
    final double latLng = prefs.getDouble('latlocal') ?? 0;
    final double lng = prefs.getDouble('lnglocal') ?? 0;

    if (radius != 0 && latLng != 0.0 && lng != 0.0) {
      searchBloc.add(SearchRadiusEvent(
          latLng, lng, radius, textEditingController.text, data.offset, true));
    } else {
      searchBloc.add(LoadingSearchAddressEvent(
          textEditingController.text, UtilsCommon.getTab(), true, data.offset));
    }
  }

  Future<void> removeItem(int id, bool share) async {
    var pref = await SharedPreferences.getInstance();
    if (share) {
      final listHis = pref.getStringList("listPlace");
      if (listHis != null && listHis.length != 0) {
        List<PlaceShareModel> listShareTemp = [];

        for (var item in listHis) {
          PlaceShareModel pl = PlaceShareModel.fromJson(jsonDecode(item));
          listShareTemp.add(pl);
        }
        if (listShareTemp.length > 10) {
          listShareTemp.removeAt(0);
        }
        listShareTemp.removeWhere((element) => element.id == id);
        pref.remove("listPlace");
        List<String> listLocationHistory = [];
        for (var item in listShareTemp) {
          listLocationHistory.add(json.encode(item));
        }
        pref.setStringList("listPlace", listLocationHistory);
      } else {
        removeShare(searchBloc);
      }
    } else {
      final listHis = pref.getStringList("listHis");

      if (listHis != null && listHis.length != 0) {
        List<PlaceLocationModel> listPlaceLocation = [];

        for (var item in listHis) {
          PlaceLocationModel pl = PlaceLocationModel.fromJson(jsonDecode(item));
          listPlaceLocation.add(pl);
        }

        listPlaceLocation.removeWhere((element) => element.id == id);
        pref.remove("listHis");
        List<String> listLocationHistory = [];
        for (var item in listPlaceLocation) {
          listLocationHistory.add(json.encode(item));
        }
        pref.setStringList("listHis", listLocationHistory);
        // onResetHistory(listPlaceLocation);
      } else {
        removeShare(searchBloc);
      }
    }
    //listPlace = [];
    getValueSharePreference(searchBloc);
  }

  void cleanMap(int type, String nameType) {
    if (listPlace.isNotEmpty) {
      switch (type) {
        case 1:

          ///clear marker
          listPlace.removeWhere((element) => element.type == 'places');
          break;
        case 2:

          /// clear polyline
          listPlace.removeWhere((element) => element.type == 'streets');
          break;
        case 3:

          /// clean polygon and type name
          listPlace.removeWhere((element) => element.type == nameType);

          break;
        case 0:
          listPlace = [];
          // param.dataHistory = [];
          getValueSharePreference(searchBloc);

          /// clean all
          break;
      }
    }
  }

  Future<void> _searchEvent(String value) async {
    final SharedPreferences prefs = await _prefs;
    final int radius = (prefs.getInt('radiusValue') ?? 0);
    final double latLng = prefs.getDouble('latlocal') ?? 0;
    final double lng = prefs.getDouble('lnglocal') ?? 0;
    List<String> type = [];
    Data.listTab.map((element) {
      if (element["checked"] == true) {
        type.add(element["id"].toString());
      }
    }).toList();
    if (radius != 0 && latLng != 0.0 && lng != 0.0) {
      searchBloc.add(SearchRadiusEvent(latLng, lng, radius, value, 0, false));
    } else {
      searchBloc.add(
          LoadingSearchAddressEvent(value, UtilsCommon.getTab(), false, 0));
    }
  }

  Future<void> _saveDataSearch(String dataSearch) async {
    final SharedPreferences prefs = await _prefs;
    if (dataSearch.isEmpty) {
      prefs.setString("dataSearch", "");
    } else {
      prefs.setString("dataSearch", dataSearch);
    }
  }

  Future<void> _getBackToHome() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove("dataSearch");
    FocusScope.of(context).requestFocus(FocusNode());
    // buttonInSearchBloc.add(ShowHistoryEvent(false));

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    listPlace = [];
    data = Result();
    searchBloc = BlocProvider.of<SearchBloc>(context);
    mapBloc = BlocProvider.of<MapBloc>(context);
    buttonInSearchBloc = BlocProvider.of<ButtonInSearchBloc>(context);
    detailMapBloc = BlocProvider.of<DetailMapBloc>(context);
    UtilsCommon.setDataFromInput(true);
    textEditingController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    detailMapBloc.add(ShowDescriptionEvent(false));
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (showSearch && listPlace.length == 0) {
      getValueSharePreference(searchBloc);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      key: scaffoldKey,
      body: BlocBuilder<ButtonInSearchBloc, ButtonInSearchState>(
          builder: (context, state) {
        if (state is ShowHistoryState) {
          showSearch = state.show;
        } else if (state is LoadingShowHistory) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
          );
        }
        return Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SearchInputWidget(
                      autoFocus: true,
                      readonly: false,
                      hasShadowBox: false,
                      onChanged: (value) {
                        _saveDataSearch(value);
                      },
                      onSubmitted: _searchEvent,
                      controller: textEditingController,
                      suffixIcon: GestureDetector(
                          onTap: () {
                            _searchEvent(textEditingController.text);
                          },
                          child: Container(
                              color: Colors.transparent,
                              child: Icon(Icons.search,
                                  color: LightTheme.colorMain))),
                      prefixIcon: GestureDetector(
                        onTap: _getBackToHome,
                        child: Container(
                          color: Colors.transparent,
                          child: Icon(
                            Icons.chevron_left,
                            size: 35,
                            color: LightTheme.colorMain,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: TabBarWidget(
                  isDataFromInput: true,
                  textEditingController: textDataSearch,
                ),
              ),
              Expanded(child: renderSearch()),
            ].where((element) => element != null).toList(),
          ),
        );
      }),
    );
  }

  void _onLoadMore() async {
    await Future.delayed(Duration(milliseconds: 1000));

    _getRadius(searchBloc);
    _refreshController.loadComplete();
  }

  Widget renderSearch() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is LoadSuccessSearchAddressState) {
          listPlace = [];

          dataShare = false;

          data = state.listPlace;
          listPlace.addAll(data.result);
          showDelete = state.show;
          textHistory = state.textHistory;
          if (data.result.length > 0) {
            loadmore = true;
          }
          mapBloc.add(BindingSearchEvent(listPlace));
        } else if (state is LoadFailSearchAddressState) {
        } else if (state is DeleteSearchSuccessAddressState) {
          listPlace = [];
          textHistory = "";

          showDelete = state.show;
          mapBloc.add(BindingSearchEvent(listPlace));
        } else if (state is LoadMoreSearchAddressState) {
          data = state.listPlace;
          if (data.result.length == 0) {
            loadmore = false;
          }
          listPlace.addAll(data.result);
          dataShare = false;

          mapBloc.add(BindingSearchEvent(listPlace));
        } else if (state is LoadSuccessSearchRadiusState) {
          listPlace = [];
          dataShare = false;
          data = state.listPlace;
          listPlace.addAll(state.listPlace.result);

          showDelete = state.show;
          textHistory = state.textHistory;
        } else if (state is LoadMoreSuccessSearchRadiusState) {
          data = state.listPlace;
          listPlace.addAll(data.result);

          dataShare = false;
          if (data.result.length == 0) {
            loadmore = false;
          } else {}
        } else if (state is BindingDataShareState) {
          listPlace = [];
          dataShare = state.dataShare;
          data = state.listPlace;
          listPlace.addAll(state.listPlace.result);
          showDelete = state.show;
          textHistory = state.textHistory;
          loadmore = false;
        } else if (state is LoadSuccessMarkerHisState) {
          if (dataShare || state.place.length != 0) {
            listPlace = [];
          }
          listPlace.addAll(state.place);
          loadmore = false;
          textHistory = state.textHis;
          showDelete = state.show;
          dataShare = false;
        } else if (state is LoadSuccessPolygonHisState) {
          if (dataShare) {
            listPlace = [];
          }
          listPlace.addAll(state.data);
          loadmore = false;
          textHistory = state.textHis;
          showDelete = state.show;
          dataShare = false;
        } else if (state is LoadSuccessPolylineHisState) {
          if (dataShare) {
            listPlace = [];
          }
          listPlace.addAll(state.data);
          loadmore = false;
          textHistory = state.textHis;
          showDelete = state.show;
          dataShare = false;
        } else if (state is DeleteSuccessMarkerHisState) {
          cleanMap(1, "");
        } else if (state is DeleteSuccessPolygonHisState) {
          String type = UtilsCommon.convertTypeString(state.typeId);

          cleanMap(3, type);
        } else if (state is DeleteSuccessPolylineHisState) {
          cleanMap(2, "");
        }
        if (listPlace.length == 0) {
          return Container(
            child: Center(
              child: Text("Không có dữ liệu cần tìm!"),
            ),
          );
        }
        return Container(
          child: Column(
            children: [
              listPlace.length > 0
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            textHistory,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: LightTheme.colorMain),
                          ),
                          showDelete
                              ? GestureDetector(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_forever,
                                        color: LightTheme.colorMain,
                                      ),
                                      Text(
                                        "Xóa " + textHistory.toLowerCase(),
                                        style: TextStyle(
                                            color: LightTheme.colorMain),
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    if (dataShare) {
                                      removeShare(searchBloc);
                                    } else {
                                      textEditingController.clear();
                                      searchBloc.add(
                                          DeleteSearchAddressEvent("", false));
                                      mapBloc.add(BindingDeleteHistoryEvent());
                                    }
                                  },
                                )
                              : null
                        ].where((element) => element != null).toList(),
                      ),
                    )
                  : null,
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: SmartRefresher(
                  enablePullDown: false,
                  enablePullUp: true,
                  header: WaterDropHeader(),
                  footer: ClassicFooter(
                    loadingText: "",
                    canLoadingText: "",
                    idleText: "",
                    idleIcon: SizedBox(),
                    loadStyle: LoadStyle.ShowWhenLoading,
                  ),
                  controller: _refreshController,
                  // onRefresh: _onRefresh,
                  onLoading: _onLoadMore,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                            padding: EdgeInsets.all(0),
                            physics: new NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: listPlace.length,
                            itemBuilder: (context, number) {
                              return ListTile(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      MapOverviewDetail.routeName,
                                      arguments: ParamMapDetail(
                                          paramRequest: ParamRequest(
                                              id: listPlace[number].id,
                                              type: listPlace[number].type,
                                              idPlace: 0),
                                          type: 1));
                                },
                                leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: 25.0,
                                        height: 25.0,
                                        decoration: BoxDecoration(
                                            color: LightTheme.colorMain,
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        child: Icon(
                                          !dataShare
                                              ? Icons.place
                                              : Icons.history,
                                          color: Colors.white,
                                          size: 15.0,
                                        )),
                                  ],
                                ),
                                title: Text(
                                  listPlace[number].name,
                                  textScaleFactor: 1,
                                ),
                                trailing: GestureDetector(
                                  child: Icon(
                                    !dataShare
                                        ? Icons.info_outline
                                        : Icons.clear,
                                    color: LightTheme.colorMain,
                                  ),
                                  onTap: () {
                                    if (!dataShare) {
                                      Navigator.of(context).pushNamed(
                                          DetailPlaceScreen.routeName,
                                          arguments: PlaceDetailModel(
                                            id: listPlace[number].id,
                                            type: listPlace[number].type,
                                          ));
                                    } else {
                                      removeItem(listPlace[number].id,
                                          listPlace[number].share);
                                    }
                                  },
                                ),
                                subtitle: Text(listPlace[number]
                                        .points[0]
                                        .lat
                                        .toString() +
                                    ", " +
                                    listPlace[number].points[0].lng.toString()),
                              );
                            }),
                        Container(
                          padding: EdgeInsets.all(0),
                          child: loadmore && listPlace.length > 0
                              ? const SizedBox()
                              : listPlace.length < 0
                                  ? Container(
                                      child: Text("Nhập từ khóa"),
                                    )
                                  : null,
                        ),
                        SizedBox(
                          height: 10.0,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ].where((element) => element != null).toList(),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
