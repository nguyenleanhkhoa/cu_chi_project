import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cuchi/src/datas/data_morkup.dart';
import 'package:meta/meta.dart';

part 'tab_bar_type_event.dart';
part 'tab_bar_type_state.dart';

class TabBarTypeBloc extends Bloc<TabBarTypeEvent, TabBarTypeState> {
  TabBarTypeBloc() : super(TabBarTypeInitial());

  @override
  Stream<TabBarTypeState> mapEventToState(TabBarTypeEvent event) async* {
    if (event is SelectTabBarTypeEvent) {
      yield await eventSelectTabBarType(event.typeId);
    } else if (event is EnableCheckEvent) {
      yield await eventEnableCheck(event.check);
    } else if (event is RemoteAllTabEvent) {
      yield await eventRemoveAllTab();
    }
  }

  Future<TabBarTypeState> eventRemoveAllTab() async {
    Data.listTab.forEach((i) {
      i["checked"] = false;
    });
    return RemoveAllTabState();
  }

  Future<TabBarTypeState> eventSelectTabBarType(int typeId) async {
    var checked;

    Data.listTab.forEach((i) {
      if (i["id"] == typeId) {
        i["checked"] = !i["checked"];
        checked = i["checked"];
      }
    });
    return SelectedTabBarTypeState(checked, typeId);
  }

  Future<TabBarTypeState> eventEnableCheck(bool value) async {
    Data.listTab.forEach((i) {
      i["checked"] = value;
    });
    return EnableCheckState();
  }
}
