import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cuchi/src/model/models.dart';
import 'package:meta/meta.dart';

part 'list_location_history_event.dart';
part 'list_location_history_state.dart';

class ListLocationHistoryBloc
    extends Bloc<ListLocationHistoryEvent, ListLocationHistoryState> {
  ListLocationHistoryBloc() : super(ListLocationHistoryInitial());

  @override
  Stream<ListLocationHistoryState> mapEventToState(
      ListLocationHistoryEvent event) async* {
    if (event is ShowHistoryLocationEvent) {
      yield await eventShowHistoryList(event.listPlaceLocation);
    } else if (event is CloseHistoryLocationEvent) {
      yield await eventCloseHistoryList();
    }
  }

  Future<ListLocationHistoryState> eventShowHistoryList(
      List<PlaceLocationModel> listPlaceLocationModel) async {
    return ShowHistoryLocationState(listPlaceLocationModel);
  }

  Future<ListLocationHistoryState> eventCloseHistoryList() async {
    return CLoseHistoryLocationState();
  }
}
