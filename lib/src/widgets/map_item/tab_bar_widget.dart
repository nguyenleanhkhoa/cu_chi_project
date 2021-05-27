import 'package:cuchi/src/bloc/map_bloc/map.bloc.dart';
import 'package:cuchi/src/bloc/search_bloc/list_search_bloc/search_bloc.dart';
import 'package:cuchi/src/bloc/tool_bloc/detail_map_bloc/detail_map_bloc.dart';
import 'package:cuchi/src/bloc/tool_bloc/near_by_bloc/near_by_bloc.dart';
import 'package:cuchi/src/bloc/tool_bloc/tab_bar_type_bloc/tab_bar_type_bloc.dart';
import 'package:cuchi/src/datas/data_morkup.dart';
import 'package:cuchi/src/utils/UtilsCommon.dart';
import 'package:cuchi/src/widgets/map_item/tab_bar_type.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabBarWidget extends StatefulWidget {
  String textEditingController;
  bool isDataFromInput;
  // TabController defaultTabController;
  TabController controller;
  TabBarWidget(
      {this.textEditingController,
      this.controller,
      this.isDataFromInput = true});

  @override
  _TabBarWidgetState createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget>
    with SingleTickerProviderStateMixin {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  MapBloc mapBloc;

  SearchBloc searchBloc;

  DetailMapBloc detailMapBloc;

  TabBarTypeBloc tabBarTypeBloc;

  NearByBloc nearByBloc;

  bool hisView;

  @override
  void initState() {
    mapBloc = BlocProvider.of<MapBloc>(context);
    detailMapBloc = BlocProvider.of<DetailMapBloc>(context);
    tabBarTypeBloc = BlocProvider.of<TabBarTypeBloc>(context);
    nearByBloc = BlocProvider.of<NearByBloc>(context);
    searchBloc = BlocProvider.of<SearchBloc>(context);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant TabBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _getDataSearch(TabBarTypeState state) async {
    final SharedPreferences prefs = await _prefs;
    String dataInput = prefs.getString("dataSearch");
    bool isDataFromInput = await UtilsCommon.checkDataFromInput();
    if (isDataFromInput != null && isDataFromInput) {
      return;
    }

    if (state is SelectedTabBarTypeState) {
      detailMapBloc.add(ShowDescriptionEvent(false));
      if (state.checked && !widget.isDataFromInput) {
        if (dataInput != null && dataInput != "") {
          _searchEvent();
        } else if (dataInput == null) {
          if (widget.isDataFromInput && dataInput == null) {
            return;
          }
          nearByBloc.add(DisplayNearByEvent(false, 0, 0));

          if (state.typeId == 1) {
            mapBloc.add(LoadingMarkerEvent(dataInput ?? ""));
            searchBloc.add(LoaddingMarkerHisEvent(dataInput ?? ""));
          } else if (state.typeId == 4) {
            mapBloc.add(LoadingPolylineIdEvent(dataInput ?? ""));
            searchBloc.add(LoadingPolylineHisEvent(dataInput ?? ""));
          } else {
            mapBloc.add(LoadingPolygonIdEvent(state.typeId, dataInput ?? ""));
            searchBloc
                .add(LoadingPolygonIdHisEvent(state.typeId, dataInput ?? ""));
          }
        }
      } else {
        if (state.typeId == 4) {
          mapBloc.add(DeletePolylineEvent());
          searchBloc.add(DeletePolylineHisEvent());
        } else if (state.typeId == 1) {
          mapBloc.add(DeleteMarkerEvent());
          searchBloc.add(DeleteMarkerHisEvent());
        } else {
          mapBloc.add(DeletePolygonIdEvent(state.typeId));
          searchBloc.add(DeletePolygonIdHisEvent(state.typeId));
        }
      }
    } else if (state is RemoveAllTabState) {
      mapBloc.add(BindingDeleteHistoryEvent());
    }
  }

  Future<void> _searchEvent() async {
    final SharedPreferences prefs = await _prefs;
    String dataInput = prefs.getString("dataSearch");

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
      searchBloc
          .add(SearchRadiusEvent(latLng, lng, radius, dataInput, 0, false));
    } else {
      searchBloc.add(
          LoadingSearchAddressEvent(dataInput, UtilsCommon.getTab(), false, 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
      width: MediaQuery.of(context).size.width,
      child: DefaultTabController(
        initialIndex: 0,
        length: Data.listTab.length,
        child: BlocConsumer<TabBarTypeBloc, TabBarTypeState>(
          listener: (ctx, state) {
            _getDataSearch(state);
          },
          builder: (context, state) {
            if (state is RemoveAllTabState) {}
            return TabBar(
              controller: widget.controller,
              onTap: (value) {
                tabBarTypeBloc
                    .add(SelectTabBarTypeEvent(Data.listTab[value]['id']));
              },
              labelPadding: EdgeInsets.only(left: 15, right: 5),
              indicatorPadding: EdgeInsets.only(left: 5),
              isScrollable: true,
              labelColor: Colors.black87,
              indicatorColor: Colors.transparent,
              unselectedLabelColor: Colors.black54,
              // mouseCursor: MouseCursor.defer,
              tabs: renderListTabWidget(),
            );
          },
        ),
      ),
    ));
  }

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
}
